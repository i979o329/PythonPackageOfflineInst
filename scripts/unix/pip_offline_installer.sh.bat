#!/bin/bash

# ============================================================================
#  PIP Offline Package Installer
#  Author: ioWiz
#  Description: Automates downloading and installing Python packages offline
#  Version: 1.0
#  License: MIT
# ============================================================================

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Function to print colored output
print_error() { echo -e "${RED}[ERROR]${NC} $1"; }
print_success() { echo -e "${GREEN}[SUCCESS]${NC} $1"; }
print_info() { echo -e "${BLUE}[INFO]${NC} $1"; }
print_warning() { echo -e "${YELLOW}[WARNING]${NC} $1"; }

# Function to check if Python is installed
check_python() {
    if ! command -v python3 &> /dev/null; then
        print_error "Python 3 is not installed or not in PATH!"
        echo "Please install Python 3 and try again."
        exit 1
    fi
}

# Function to check if pip is installed
check_pip() {
    if ! python3 -m pip --version &> /dev/null; then
        print_error "pip is not installed or not available!"
        echo "Please install pip and try again."
        exit 1
    fi
}

# Function to display header
display_header() {
    clear
    echo -e "${CYAN}"
    echo "============================================================================"
    echo "                    PIP OFFLINE PACKAGE INSTALLER"
    echo "                           by ioWiz"
    echo "============================================================================"
    echo -e "${NC}"
    echo "  Current Directory: $(pwd)"
    echo "  Python Version: $(python3 --version)"
    echo "  pip Version: $(python3 -m pip --version)"
    echo ""
    echo "============================================================================"
}

# Function to display main menu
display_menu() {
    display_header
    echo ""
    echo "  [1] Download Packages (Online Mode)"
    echo "  [2] Install Packages from Offline Directory"
    echo "  [3] List Downloaded Packages"
    echo "  [4] Create requirements.txt from installed packages"
    echo "  [5] Help & Documentation"
    echo "  [6] Exit"
    echo ""
    echo "============================================================================"
    echo ""
}

# Function to download single package
download_single() {
    echo ""
    read -p "Enter package name (e.g., requests or pandas==1.5.0): " package
    if [ -z "$package" ]; then
        print_error "Package name cannot be empty!"
        sleep 2
        return
    fi
    echo ""
    print_info "Downloading $package and dependencies to $download_dir..."
    echo ""
    python3 -m pip download "$package" -d "$download_dir"
    if [ $? -eq 0 ]; then
        echo ""
        print_success "Package downloaded successfully!"
    else
        echo ""
        print_error "Failed to download package!"
    fi
    echo ""
    read -p "Press Enter to continue..."
}

# Function to download multiple packages
download_multiple() {
    echo ""
    echo "Enter package names separated by spaces"
    read -p "(e.g., requests numpy pandas): " packages
    if [ -z "$packages" ]; then
        print_error "Package names cannot be empty!"
        sleep 2
        return
    fi
    echo ""
    print_info "Downloading packages and dependencies to $download_dir..."
    echo ""
    for package in $packages; do
        echo "Downloading $package..."
        python3 -m pip download "$package" -d "$download_dir"
    done
    echo ""
    print_success "All packages downloaded!"
    echo ""
    read -p "Press Enter to continue..."
}

# Function to download from requirements.txt
download_requirements() {
    echo ""
    read -p "Enter requirements.txt file path [default: requirements.txt]: " req_file
    req_file=${req_file:-requirements.txt}
    
    if [ ! -f "$req_file" ]; then
        print_error "File '$req_file' not found!"
        echo ""
        read -p "Press Enter to continue..."
        return
    fi
    echo ""
    print_info "Downloading packages from $req_file to $download_dir..."
    echo ""
    python3 -m pip download -r "$req_file" -d "$download_dir"
    if [ $? -eq 0 ]; then
        echo ""
        print_success "All packages from requirements.txt downloaded!"
    else
        echo ""
        print_error "Failed to download some packages!"
    fi
    echo ""
    read -p "Press Enter to continue..."
}

# Function to handle download menu
download_packages() {
    clear
    echo ""
    echo "============================================================================"
    echo "                         DOWNLOAD PACKAGES"
    echo "============================================================================"
    echo ""
    echo "This option downloads packages and all their dependencies."
    echo ""
    read -p "Enter offline packages directory name [default: offline_packages]: " download_dir
    download_dir=${download_dir:-offline_packages}
    
    # Create directory if it doesn't exist
    if [ ! -d "$download_dir" ]; then
        mkdir -p "$download_dir"
        print_info "Created directory: $download_dir"
    else
        print_info "Using existing directory: $download_dir"
    fi
    echo ""
    
    echo "Choose download method:"
    echo "  [1] Single package"
    echo "  [2] Multiple packages (space-separated)"
    echo "  [3] From requirements.txt file"
    echo ""
    read -p "Enter your choice (1-3): " dl_method
    
    case $dl_method in
        1) download_single ;;
        2) download_multiple ;;
        3) download_requirements ;;
        *) print_warning "Invalid choice!"; sleep 2 ;;
    esac
}

# Function to install single package
install_single() {
    echo ""
    read -p "Enter package name to install: " package
    if [ -z "$package" ]; then
        print_error "Package name cannot be empty!"
        sleep 2
        return
    fi
    echo ""
    print_info "Installing $package from offline packages..."
    echo ""
    python3 -m pip install --no-index --find-links="$install_dir" "$package"
    if [ $? -eq 0 ]; then
        echo ""
        print_success "Package installed successfully!"
    else
        echo ""
        print_error "Failed to install package!"
    fi
    echo ""
    read -p "Press Enter to continue..."
}

# Function to install all packages
install_all() {
    echo ""
    read -p "This will install ALL packages from '$install_dir'. Continue? (Y/N): " confirm
    if [[ ! "$confirm" =~ ^[Yy]$ ]]; then
        return
    fi
    echo ""
    print_info "Installing all packages from offline directory..."
    echo ""
    for wheel in "$install_dir"/*.whl; do
        if [ -f "$wheel" ]; then
            echo "Installing $(basename "$wheel")..."
            python3 -m pip install --no-index --find-links="$install_dir" "$wheel"
        fi
    done
    echo ""
    print_success "Installation complete!"
    echo ""
    read -p "Press Enter to continue..."
}

# Function to install from requirements.txt offline
install_requirements_offline() {
    echo ""
    read -p "Enter requirements.txt file path [default: requirements.txt]: " req_file
    req_file=${req_file:-requirements.txt}
    
    if [ ! -f "$req_file" ]; then
        print_error "File '$req_file' not found!"
        echo ""
        read -p "Press Enter to continue..."
        return
    fi
    echo ""
    print_info "Installing packages from $req_file (offline mode)..."
    echo ""
    python3 -m pip install --no-index --find-links="$install_dir" -r "$req_file"
    if [ $? -eq 0 ]; then
        echo ""
        print_success "All packages installed successfully!"
    else
        echo ""
        print_error "Failed to install some packages!"
    fi
    echo ""
    read -p "Press Enter to continue..."
}

# Function to handle install menu
install_packages() {
    clear
    echo ""
    echo "============================================================================"
    echo "                    INSTALL PACKAGES (OFFLINE MODE)"
    echo "============================================================================"
    echo ""
    echo "This option installs packages WITHOUT internet connection."
    echo ""
    read -p "Enter offline packages directory name [default: offline_packages]: " install_dir
    install_dir=${install_dir:-offline_packages}
    
    if [ ! -d "$install_dir" ]; then
        echo ""
        print_error "Directory '$install_dir' does not exist!"
        echo "Please download packages first using Option 1."
        echo ""
        read -p "Press Enter to continue..."
        return
    fi
    
    # Count wheel files
    count=$(ls -1 "$install_dir"/*.whl 2>/dev/null | wc -l)
    
    if [ "$count" -eq 0 ]; then
        echo ""
        print_error "No wheel files (.whl) found in '$install_dir'!"
        echo "Please download packages first using Option 1."
        echo ""
        read -p "Press Enter to continue..."
        return
    fi
    
    echo ""
    echo "Found $count wheel file(s) in '$install_dir'"
    echo ""
    echo "Choose installation method:"
    echo "  [1] Install specific package"
    echo "  [2] Install all packages in directory"
    echo "  [3] Install from requirements.txt (offline)"
    echo ""
    read -p "Enter your choice (1-3): " inst_method
    
    case $inst_method in
        1) install_single ;;
        2) install_all ;;
        3) install_requirements_offline ;;
        *) print_warning "Invalid choice!"; sleep 2 ;;
    esac
}

# Function to list packages
list_packages() {
    clear
    echo ""
    echo "============================================================================"
    echo "                       DOWNLOADED PACKAGES LIST"
    echo "============================================================================"
    echo ""
    read -p "Enter offline packages directory name [default: offline_packages]: " list_dir
    list_dir=${list_dir:-offline_packages}
    
    if [ ! -d "$list_dir" ]; then
        echo ""
        print_error "Directory '$list_dir' does not exist!"
        echo ""
        read -p "Press Enter to continue..."
        return
    fi
    
    echo ""
    echo "Contents of '$list_dir':"
    echo "============================================================================"
    echo ""
    
    count=0
    for wheel in "$list_dir"/*.whl; do
        if [ -f "$wheel" ]; then
            ((count++))
            echo "[$count] $(basename "$wheel")"
        fi
    done
    
    if [ "$count" -eq 0 ]; then
        echo "No wheel files found in this directory."
    else
        echo ""
        echo "============================================================================"
        echo "Total: $count package(s)"
    fi
    
    echo ""
    echo "Other files in directory:"
    echo ""
    for file in "$list_dir"/*; do
        if [ -f "$file" ] && [[ ! "$file" =~ \.whl$ ]]; then
            echo "  - $(basename "$file")"
        fi
    done
    
    echo ""
    read -p "Press Enter to continue..."
}

# Function to create requirements.txt
create_requirements() {
    clear
    echo ""
    echo "============================================================================"
    echo "                   CREATE REQUIREMENTS.TXT"
    echo "============================================================================"
    echo ""
    echo "This creates a requirements.txt from currently installed packages."
    echo ""
    read -p "Enter output filename [default: requirements.txt]: " req_output
    req_output=${req_output:-requirements.txt}
    echo ""
    print_info "Generating $req_output..."
    echo ""
    python3 -m pip freeze > "$req_output"
    if [ $? -eq 0 ]; then
        print_success "Requirements file created: $req_output"
        echo ""
        echo "Preview (first 10 lines):"
        echo "============================================================================"
        head -10 "$req_output"
    else
        print_error "Failed to create requirements file!"
    fi
    echo ""
    read -p "Press Enter to continue..."
}

# Function to display help
display_help() {
    clear
    echo ""
    echo "============================================================================"
    echo "                        HELP & DOCUMENTATION"
    echo "============================================================================"
    echo ""
    echo "OVERVIEW:"
    echo "This tool helps you install Python packages without internet connection."
    echo ""
    echo "WORKFLOW:"
    echo "  1. On an ONLINE machine: Use Option 1 to download packages"
    echo "  2. Transfer the 'offline_packages' folder to your offline machine"
    echo "  3. On the OFFLINE machine: Use Option 2 to install packages"
    echo ""
    echo "============================================================================"
    echo ""
    echo "OPTION 1 - DOWNLOAD PACKAGES:"
    echo "  Downloads packages and ALL dependencies as .whl files"
    echo "  Requires: Internet connection"
    echo "  Command used: pip download <package> -d <directory>"
    echo ""
    echo "OPTION 2 - INSTALL OFFLINE:"
    echo "  Installs packages from local .whl files"
    echo "  Requires: No internet needed"
    echo "  Command used: pip install --no-index --find-links=<dir> <package>"
    echo ""
    echo "OPTION 3 - LIST PACKAGES:"
    echo "  Shows all downloaded .whl files in your offline directory"
    echo ""
    echo "OPTION 4 - CREATE REQUIREMENTS:"
    echo "  Generates requirements.txt from currently installed packages"
    echo "  Command used: pip freeze > requirements.txt"
    echo ""
    echo "============================================================================"
    echo ""
    echo "TIPS:"
    echo "  - Always download on the SAME platform (Windows/Linux/Mac) as target"
    echo "  - Specify versions if needed: package==1.2.3"
    echo "  - Use requirements.txt for multiple packages"
    echo "  - Keep offline_packages folder organized by project"
    echo ""
    echo "COMMON ISSUES:"
    echo "  - 'No matching distribution': Wrong Python version or platform"
    echo "  - 'Permission denied': Run with sudo or use virtual environment"
    echo "  - 'Failed to download': Check internet connection and package name"
    echo ""
    echo "============================================================================"
    echo ""
    echo "For more help, visit: https://pip.pypa.io/en/stable/"
    echo ""
    read -p "Press Enter to continue..."
}

# Main program
main() {
    # Check prerequisites
    check_python
    check_pip
    
    # Main loop
    while true; do
        display_menu
        read -p "Enter your choice (1-6): " choice
        
        case $choice in
            1) download_packages ;;
            2) install_packages ;;
            3) list_packages ;;
            4) create_requirements ;;
            5) display_help ;;
            6) 
                clear
                echo ""
                echo "============================================================================"
                echo ""
                echo "  Thank you for using PIP Offline Package Installer by ioWiz!"
                echo ""
                echo "  Subscribe to ioWiz on YouTube for more Python tutorials!"
                echo ""
                echo "============================================================================"
                echo ""
                sleep 2
                exit 0
                ;;
            *) 
                print_warning "Invalid choice! Please enter a number between 1 and 6."
                sleep 2
                ;;
        esac
    done
}

# Run main program
main