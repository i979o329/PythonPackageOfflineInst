# Offline Python Package Installer

#### This tool helps you to download a Python package (including all of its direct and dependent *.whl files in folder), so that the Python package can be easily install on a machine without internet connection.

## Workflow
###### 1. On an ONLINE machine: Use Option 1 to download packages
###### 2. Transfer the 'offline_packages' folder to your offline machine
###### 3. On the OFFLINE machine: Use Option 2 to install packages

---

## Script Options
#### OPTION 1 - DOWNLOAD PACKAGES:
###### Downloads packages and ALL dependencies as .whl files
##### Requires: Internet connection
    # Command used: pip download <package> -d <directory>

#### OPTION 2 - INSTALL OFFLINE:
###### Installs packages from local .whl files
##### Requires: No internet needed
    # Command used: pip install --no-index --find-links=<dir> <package>

#### OPTION 3 - LIST PACKAGES:
###### Shows all downloaded .whl files in your offline directory

#### OPTION 4 - CREATE REQUIREMENTS:
###### Generates requirements.txt from currently installed packages
    # Command used: pip freeze > requirements.txt

---

## Workflow
###### 1. On an ONLINE machine: Use Option 1 to download packages
###### 2. Transfer the 'offline_packages' folder to your offline machine
###### 3. On the OFFLINE machine: Use Option 2 to install packages

---

## TIPS:
  - Always download on the SAME platform (Windows/Linux/Mac) as target
  - Specify versions if needed: package==1.2.3
  - Use requirements.txt for multiple packages
  - Keep offline_packages folder organized by project

---

## COMMON ISSUES:
  - "No matching distribution": Wrong Python version or platform
  - "Permission denied": Run as administrator or use virtual environment
  - "Failed to download": Check internet connection and package name

---


## Contributing

Pull requests are welcome. For major changes, please open an issue first
to discuss what you would like to change.

Please make sure to update tests as appropriate.

---

## License

[MIT](https://choosealicense.com/licenses/mit/)