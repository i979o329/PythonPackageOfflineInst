## TROUBLESHOOTING GUIDE

### Problem 1: "No matching distribution found"
**Cause:** Package downloaded for wrong platform or Python version

**Solutions:**
- Check Python version: `python --version`
- Download for correct platform using flags:
  ```bash
  pip download --platform win_amd64 --python-version 39 package_name -d ./offline_packages
  ```
- Ensure both machines have same Python version (major.minor)

---

### Problem 2: "Could not find a version that satisfies the requirement"
**Cause:** Package name typo or version doesn't exist

**Solutions:**
- Verify package name on PyPI.org
- Check available versions: `pip index versions package_name` (on online machine)
- Try without version specification first
- Check for spelling errors

---

### Problem 3: "Permission denied" or "Access is denied"
**Cause:** Installing to system directories without admin rights

**Solutions:**
- **Windows:** Run Command Prompt as Administrator
- **Linux/Mac:** Use `sudo pip install...` or install in virtual environment
- **Better approach:** Always use virtual environments:
  ```bash
  python -m venv myenv
  myenv\Scripts\activate  # Windows
  source myenv/bin/activate  # Linux/Mac
  ```

---

### Problem 4: Dependency Conflicts
**Cause:** Package requires different versions of same dependency

**Solutions:**
- Use requirements.txt with pinned versions:
  ```
  package1==1.2.3
  package2==2.3.4
  dependency==0.5.0
  ```
- Download complete dependency tree at once
- Use dependency resolver: `pip install --use-feature=2020-resolver`

---

### Problem 5: "ERROR: Failed building wheel"
**Cause:** Package requires compilation but compiler not available

**Solutions:**
- Download pre-built wheels (`.whl` files)
- Use `--only-binary=:all:` flag when downloading:
  ```bash
  pip download --only-binary=:all: package_name -d ./offline_packages
  ```
- Install build tools (Visual C++ for Windows, build-essential for Linux)

---

### Problem 6: "Hash mismatch" errors
**Cause:** File corruption during transfer

**Solutions:**
- Re-download the package
- Verify file integrity using checksums
- Use reliable transfer method (avoid email for large files)
- Check USB drive for errors

---

### Problem 7: Missing Dependencies
**Cause:** Some dependencies weren't downloaded

**Solutions:**
- Always use `pip download` (not manual download)
- Let pip handle dependencies automatically
- If issue persists, download each dependency manually:
  ```bash
  pip show package_name  # Check required dependencies
  pip download dependency_name -d ./offline_packages
  ```