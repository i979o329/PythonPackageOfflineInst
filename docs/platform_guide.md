## PLATFORM COMPATIBILITY CHART

| Platform | Python Version | Platform Tag | Example Command |
|----------|---------------|--------------|-----------------|
| **Windows 64-bit** | 3.9 | win_amd64 | `pip download --platform win_amd64 --python-version 39 package -d ./offline` |
| **Windows 32-bit** | 3.9 | win32 | `pip download --platform win32 --python-version 39 package -d ./offline` |
| **Linux 64-bit** | 3.9 | manylinux2014_x86_64 | `pip download --platform manylinux2014_x86_64 --python-version 39 package -d ./offline` |
| **Linux 32-bit** | 3.9 | manylinux2014_i686 | `pip download --platform manylinux2014_i686 --python-version 39 package -d ./offline` |
| **macOS Intel** | 3.9 | macosx_10_9_x86_64 | `pip download --platform macosx_10_9_x86_64 --python-version 39 package -d ./offline` |
| **macOS ARM (M1/M2)** | 3.9 | macosx_11_0_arm64 | `pip download --platform macosx_11_0_arm64 --python-version 39 package -d ./offline` |

### Python Version Tags
- Python 3.8 → `38`
- Python 3.9 → `39`
- Python 3.10 → `310`
- Python 3.11 → `311`
- Python 3.12 → `312`