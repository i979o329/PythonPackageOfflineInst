## 2. QUICK REFERENCE COMMAND CHEAT SHEET

### Download Commands
```bash
# Download single package
pip download package_name -d ./offline_packages

# Download specific version
pip download package_name==1.2.3 -d ./offline_packages

# Download from requirements.txt
pip download -r requirements.txt -d ./offline_packages

# Download for specific platform (Windows example)
pip download --platform win_amd64 --python-version 39 --only-binary=:all: package_name -d ./offline_packages

# Download for Linux
pip download --platform manylinux2014_x86_64 --python-version 39 package_name -d ./offline_packages

# Download for macOS
pip download --platform macosx_10_9_x86_64 --python-version 39 package_name -d ./offline_packages
```

### Install Commands
```bash
# Install single package offline
pip install --no-index --find-links=./offline_packages package_name

# Install all packages from directory
pip install --no-index --find-links=./offline_packages *.whl

# Install from requirements.txt offline
pip install --no-index --find-links=./offline_packages -r requirements.txt

# Install specific version offline
pip install --no-index --find-links=./offline_packages package_name==1.2.3
```

### Utility Commands
```bash
# List installed packages
pip list

# Create requirements.txt from installed packages
pip freeze > requirements.txt

# Show package details
pip show package_name

# Check package dependencies
pip show package_name | grep Requires

# Verify installation
python -c "import package_name; print(package_name.__version__)"

# List outdated packages
pip list --outdated
```

### Virtual Environment Commands
```bash
# Create virtual environment
python -m venv myenv

# Activate (Windows)
myenv\Scripts\activate

# Activate (Linux/Mac)
source myenv/bin/activate

# Deactivate
deactivate

# Install packages in virtual environment (offline)
pip install --no-index --find-links=./offline_packages -r requirements.txt
```