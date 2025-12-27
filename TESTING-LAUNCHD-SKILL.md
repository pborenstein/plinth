# Testing Guide: macos-launchd-service Skill

Step-by-step guide for testing the launchd service skill on existing nahuatl projects.

**Purpose**: Verify templates generate correct files and scripts work properly.

**Test projects**: temoa and apantli (both have existing launchd setups)

---

## Prerequisites

- [ ] plinth repository at `/Users/philip/projects/plinth`
- [ ] temoa at `/Users/philip/projects/nahuatl-projects/temoa`
- [ ] apantli at `/Users/philip/projects/nahuatl-projects/apantli`
- [ ] Both projects have existing `launchd/` directories to compare against

---

## Test Plan Overview

1. Choose test project (temoa recommended - simpler setup)
2. Backup existing launchd setup
3. Manually generate files from templates (simulate skill execution)
4. Compare generated files to existing files
5. Test generated scripts work
6. Verify service installs and runs
7. Test uninstaller
8. Restore backup or keep new files if better

---

## Phase 1: Setup and Backup

### 1.1 Choose Test Project

**Recommended**: Start with temoa (simpler - no Tailscale)

```bash
cd ~/projects/nahuatl-projects/temoa
```

### 1.2 Backup Existing launchd Directory

```bash
# Create backup
cp -r launchd launchd.backup
cp dev.sh dev.sh.backup
cp view-logs.sh view-logs.sh.backup

# Verify backup
ls -la launchd.backup/
ls -la *.backup
```

### 1.3 Document Existing Setup

Capture what's currently there for comparison:

```bash
# What files exist
ls -la launchd/

# Current service label
grep "<string>dev\." launchd/temoa.plist.template

# Current plist structure
cat launchd/temoa.plist.template

# Record current parameters
echo "Project: temoa"
echo "Port: 4001"
echo "Domain: dev.$(whoami)"  # Current uses dev.username
```

---

## Phase 2: Manual Template Substitution

Since we can't invoke the skill yet, manually generate files.

### 2.1 Create Test Script

Create a simple substitution script:

```bash
cat > /tmp/generate-launchd.sh << 'EOF'
#!/bin/bash
set -e

# Parameters (edit these for your project)
DOMAIN="dev.pborenstein"
PROJECT_NAME="temoa"
MODULE_NAME="temoa"
PORT="4001"
CLI_COMMAND='        <string>{{VENV_BIN}}/temoa</string>
        <string>server</string>
        <string>--host</string>
        <string>0.0.0.0</string>
        <string>--port</string>
        <string>4001</string>
        <string>--log-level</string>
        <string>info</string>'
DEV_COMMAND="temoa server --reload"
PROCESS_NAME="temoa server"

PLINTH_DIR="/Users/philip/projects/plinth"
TEMPLATE_DIR="$PLINTH_DIR/skills/macos-launchd-service/templates"
OUTPUT_DIR="./launchd-test"

mkdir -p "$OUTPUT_DIR"

echo "Generating files from templates..."

# Function to substitute variables
substitute() {
    local input_file="$1"
    local output_file="$2"

    sed -e "s|{{DOMAIN}}|$DOMAIN|g" \
        -e "s|{{PROJECT_NAME}}|$PROJECT_NAME|g" \
        -e "s|{{MODULE_NAME}}|$MODULE_NAME|g" \
        -e "s|{{PORT}}|$PORT|g" \
        -e "s|{{CLI_COMMAND}}|$CLI_COMMAND|g" \
        -e "s|{{DEV_COMMAND}}|$DEV_COMMAND|g" \
        -e "s|{{PROCESS_NAME}}|$PROCESS_NAME|g" \
        "$input_file" > "$output_file"
}

# Generate all files
substitute "$TEMPLATE_DIR/install.sh.template" "$OUTPUT_DIR/install.sh"
substitute "$TEMPLATE_DIR/uninstall.sh.template" "$OUTPUT_DIR/uninstall.sh"
substitute "$TEMPLATE_DIR/service.plist.template" "$OUTPUT_DIR/${PROJECT_NAME}.plist.template"
substitute "$TEMPLATE_DIR/dev.sh.template" "../dev.sh.test"
substitute "$TEMPLATE_DIR/view-logs.sh.template" "../view-logs.sh.test"

# Make scripts executable
chmod +x "$OUTPUT_DIR/install.sh"
chmod +x "$OUTPUT_DIR/uninstall.sh"
chmod +x "../dev.sh.test"
chmod +x "../view-logs.sh.test"

echo "✓ Generated files in $OUTPUT_DIR/"
ls -la "$OUTPUT_DIR/"
ls -la ../*.test
EOF

chmod +x /tmp/generate-launchd.sh
```

### 2.2 Generate Test Files

```bash
cd ~/projects/nahuatl-projects/temoa
/tmp/generate-launchd.sh
```

**Expected output**:
```
launchd-test/
├── install.sh
├── uninstall.sh
└── temoa.plist.template

../dev.sh.test
../view-logs.sh.test
```

---

## Phase 3: Compare Generated vs Existing

### 3.1 Compare Service Plist

```bash
# Side-by-side comparison
diff -u launchd/temoa.plist.template launchd-test/temoa.plist.template

# Or use a visual diff tool
code --diff launchd/temoa.plist.template launchd-test/temoa.plist.template
```

**Key differences to expect**:
- Label: `dev.philip.temoa` → `dev.pborenstein.temoa`
- Otherwise should be identical

### 3.2 Compare Install Script

```bash
diff -u launchd/install.sh launchd-test/install.sh
```

**Key differences to expect**:
- SERVICE_PLIST path uses `{{DOMAIN}}` instead of `dev.$USERNAME`
- Otherwise logic should be the same

### 3.3 Compare Dev Script

```bash
diff -u dev.sh dev.sh.test
```

**Key differences to expect**:
- No USERNAME variable (removed)
- SERVICE_PLIST uses `{{DOMAIN}}` directly
- Otherwise logic should be the same

### 3.4 Compare View Logs Script

```bash
diff -u view-logs.sh view-logs.sh.test
```

**Should be identical** (no USERNAME references in original)

### 3.5 Check Uninstaller (New)

```bash
cat launchd-test/uninstall.sh
```

**Verify**:
- Uses correct domain and project name
- Has confirmation prompt
- Stops service before removing

---

## Phase 4: Test Generated Scripts

### 4.1 Test Install Script (Dry Run)

First, check the generated plist would be correct:

```bash
cd ~/projects/nahuatl-projects/temoa

# Check what would be generated (don't install yet)
cat launchd-test/install.sh | grep "SERVICE_PLIST="
# Should show: ~/Library/LaunchAgents/dev.pborenstein.temoa.plist
```

### 4.2 Stop Existing Service

```bash
# Find current service
launchctl list | grep temoa

# Stop it
launchctl unload ~/Library/LaunchAgents/dev.$(whoami).temoa.plist 2>/dev/null || true
```

### 4.3 Install Using Generated Script

```bash
cd ~/projects/nahuatl-projects/temoa
./launchd-test/install.sh
```

**Verify output**:
- [x] Environment detected correctly
- [x] venv validated
- [x] Module import check passed
- [x] Plist generated at correct path
- [x] Service loaded
- [x] Status shows running
- [x] Access URLs displayed

### 4.4 Verify Service Running

```bash
# Check service status
launchctl list | grep temoa
# Should show: dev.pborenstein.temoa

# Check service file exists
ls ~/Library/LaunchAgents/dev.pborenstein.temoa.plist

# Check service is responding
curl http://localhost:4001
# Should get response from temoa
```

### 4.5 Test View Logs Script

```bash
# In one terminal
./view-logs.sh.test

# In another terminal, make some requests
curl http://localhost:4001

# Verify logs appear in first terminal
# Ctrl+C to stop
```

### 4.6 Test Dev Script

```bash
./dev.sh.test
```

**Verify**:
- [x] Shows "Stopping launchd service..."
- [x] Service stops successfully
- [x] Asks about caffeinate
- [x] Runs temoa with --reload flag
- [x] Accessible at localhost:4001

**Test auto-reload**:
- Make a small change to a Python file
- Verify server reloads automatically

**Exit dev mode** (Ctrl+C):
- [x] Cleanup function runs
- [x] Asks "Restore launchd service? (y/n)"
- [x] Answer 'y' and verify service restores

### 4.7 Test Uninstaller

```bash
./launchd-test/uninstall.sh
```

**Verify**:
- [x] Shows what will be removed
- [x] Asks for confirmation
- [x] Answer 'y'
- [x] Stops running service
- [x] Removes plist file
- [x] Confirms completion
- [x] Shows reinstall command

**Verify service removed**:
```bash
# Should not find service
launchctl list | grep temoa

# Plist should be gone
ls ~/Library/LaunchAgents/dev.pborenstein.temoa.plist
# Should show "No such file or directory"
```

---

## Phase 5: Validation Checklist

### 5.1 Generated Files Quality

- [ ] All 5 files generated (install, uninstall, plist, dev, view-logs)
- [ ] Scripts are executable
- [ ] No leftover `{{VARIABLES}}` in generated files
- [ ] CLI_COMMAND properly formatted as plist array
- [ ] Domain parameter used correctly throughout

### 5.2 Scripts Work Correctly

- [ ] install.sh detects environment
- [ ] install.sh validates dependencies
- [ ] install.sh creates and loads service
- [ ] Service runs and responds on correct port
- [ ] view-logs.sh shows logs correctly
- [ ] dev.sh stops service and runs with reload
- [ ] dev.sh offers to restore on exit
- [ ] uninstall.sh asks confirmation
- [ ] uninstall.sh stops service
- [ ] uninstall.sh removes plist file

### 5.3 Comparison to Existing

- [ ] Generated files similar structure to existing
- [ ] Generated files have correct domain parameter
- [ ] No regression in functionality
- [ ] Uninstaller is new addition (improvement)

---

## Phase 6: Cleanup and Decision

### 6.1 If Tests Pass

**Option A: Keep generated files**

```bash
# Remove old files
rm -rf launchd.backup dev.sh.backup view-logs.sh.backup

# Replace with generated versions
rm -rf launchd dev.sh view-logs.sh
mv launchd-test launchd
mv dev.sh.test dev.sh
mv view-logs.sh.test view-logs.sh

# Reinstall service with new files
./launchd/install.sh
```

**Option B: Restore original**

```bash
# Remove test files
rm -rf launchd-test dev.sh.test view-logs.sh.test

# Restore backup
rm -rf launchd dev.sh view-logs.sh
mv launchd.backup launchd
mv dev.sh.backup dev.sh
mv view-logs.sh.backup view-logs.sh

# Reinstall original service
./launchd/install.sh
```

### 6.2 If Tests Fail

Document what failed:

```bash
# In plinth repo
cd ~/projects/plinth

# Create issue document
cat > TESTING-RESULTS.md << EOF
# Testing Results - $(date)

## Test Project: temoa

### Issues Found:

1. [Describe issue]
   - Expected: [what should happen]
   - Actual: [what happened]
   - File: [which template/script]

2. [Next issue]

### Files with Problems:

- [ ] install.sh.template
- [ ] uninstall.sh.template
- [ ] service.plist.template
- [ ] dev.sh.template
- [ ] view-logs.sh.template

### Next Steps:

[What needs to be fixed]
EOF
```

---

## Phase 7: Test on Second Project (Optional)

If temoa tests pass, repeat on apantli:

```bash
cd ~/projects/nahuatl-projects/apantli
```

**Note**: apantli has Tailscale support - skill doesn't generate that yet.

**Modifications needed for apantli**:
- Port: 4000
- CLI_COMMAND: different (uses `python3 -m apantli.server`)
- May need to handle Tailscale plist separately

---

## Success Criteria

Phase 1 testing complete when:

- [x] Templates generate valid files
- [x] All scripts execute without errors
- [x] Service installs and runs correctly
- [x] Service accessible on specified port
- [x] Dev mode works (stop service, run with reload, restore)
- [x] Uninstaller works (confirmation, stop, remove)
- [x] Generated files comparable quality to existing
- [x] No regressions compared to manual setup

---

## Troubleshooting

**Service won't start**:
```bash
# Check error logs
tail ~/Library/Logs/temoa.error.log

# Validate plist syntax
plutil -lint ~/Library/LaunchAgents/dev.pborenstein.temoa.plist
```

**Port already in use**:
```bash
# Find what's using port
lsof -i :4001

# Kill process
kill -9 <PID>
```

**Permission errors**:
```bash
# Ensure LaunchAgents exists
mkdir -p ~/Library/LaunchAgents

# Check file permissions
ls -la ~/Library/LaunchAgents/dev.pborenstein.temoa.plist
```

**Template substitution errors**:
```bash
# Check for leftover variables
grep "{{" launchd-test/*
grep "{{" *.test
```

---

## Notes

- Keep `/tmp/generate-launchd.sh` for future testing
- Can reuse on other projects by changing parameters at top
- Document any issues found in plinth repo
- Consider adding this script to plinth as `scripts/test-launchd-skill.sh`

---

**Ready to test?** Start with Phase 1, work through sequentially.
