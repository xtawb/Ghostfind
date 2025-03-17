# Ghostfind 🛡️

**Ghostfind** is an advanced web vulnerability scanner designed to be both user-friendly and powerful. It provides a wide range of features for scanning websites and discovering security vulnerabilities.

---

## 📜 Table of Contents

- [Features](#-features)
- [Installation](#-installation)
- [Usage](#-usage)
- [Available Options](#-available-options)
- [Tools Used](#-tools-used)
- [License](#-license)
- [Contact](#-contact)

---

## 🌟 Features

- **Subdomain Enumeration**: Uses tools like **Subfinder** and **Amass** to discover subdomains.
- **Live Domain Verification**: Uses **httpx-toolkit** to verify active domains.
- **Vulnerability Scanning**: Uses **Nuclei** to detect known security vulnerabilities.
- **Web Server Scanning**: Uses **Nikto** to discover vulnerabilities in web servers.
- **Web Application Scanning**: Uses **Wapiti** to detect vulnerabilities in web applications.
- **SQL Injection Scanning**: Uses **sqlmap** to detect SQL injection vulnerabilities.
- **Directory Brute Forcing**: Uses **dirb** to search for hidden directories and files.
- **Technology Detection**: Uses **WhatWeb** to identify technologies used on the website.
- **Broken Link Check**: Uses **broken-link-checker** to detect broken links.

---

## 🛠️ Installation

1. **Ensure Git is Installed**:
   - If Git is not installed, download and install it from [here](https://git-scm.com/).

2. **Clone the Repository**:
   ```bash
   git clone https://github.com/xtawb/Ghostfind.git
   cd Ghostfind
   ```

3. **Grant Execution Permissions**:
   ```bash
   chmod +x Ghostfind.sh
   ```

4. **Install Required Tools**:
   - The required tools will be installed automatically when you run the script for the first time.

![🔗 Installation Image](https://i.postimg.cc/Bb04qdR8/Ghostfind.png)

---

## 🚀 Usage

1. **Run the Tool**:
   ```bash
   ./Ghostfind.sh
   ```

2. **Choose the Scan Type**:
   - **1) Use existing subdomains file**: Use an existing subdomains file.
   - **2) Scan new domain**: Scan a new domain.

3. **Subdomain Enumeration**:
   - If you choose to scan a new domain, you will be asked if you want to enumerate subdomains.

4. **View Results**:
   - After the scan is complete, the results will be saved in the `Ghostfind_Scan_<date_time>` folder.

---

## ⚙️ Available Options

- **Subdomain Enumeration**: Choose to enumerate subdomains or skip this step.
- **Auto-Update**: Automatically update tools and templates before starting the scan.
- **Screenshot Capture**: Capture screenshots of live websites.

---

## 🛠️ Tools Used

- **Subfinder**: For subdomain enumeration.
- **Amass**: For advanced subdomain enumeration.
- **httpx-toolkit**: For live domain verification.
- **Nuclei**: For vulnerability scanning.
- **Nikto**: For web server scanning.
- **Wapiti**: For web application scanning.
- **sqlmap**: For SQL injection scanning.
- **dirb**: For directory brute forcing.
- **WhatWeb**: For technology detection.
- **broken-link-checker**: For broken link checking.

---

## 📞 Contact

- **Developer**: [@xtawb](https://linktr.ee/xtawb)
- **Repository Link**: [Ghostfind on GitHub](https://github.com/xtawb/Ghostfind)
---

**Ghostfind** is a powerful and easy-to-use tool for discovering security vulnerabilities in websites, making it ideal for security testers and developers. 🛡️

