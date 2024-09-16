# CreepCatcher-LAPS

**CreepCatcher-LAPS** is a PowerShell script designed to detect Microsoft LAPS (Local Administrator Password Solution) permissions creep across Active Directory (AD) organizational units (OUs). The script helps identify privilege escalation by scanning for extended rights on OUs, checking for administrative permissions on LAPS-protected machines, and exporting the results to an Excel file for easy analysis.

## Features

- **Scan Top-Level OUs:** Scans all top-level Organizational Units (OUs) in your Active Directory.
- **Retrieve Extended Rights:** Retrieves extended rights for `Find-AdmPwdExtendedRights` for each OU.
- **Export to Excel:** Exports results to an Excel file for easy review and reporting.
- **Multi-threading:** Utilizes multi-threading for faster scans by processing multiple OUs at once.
- **Error Handling:** Catches and logs errors without halting the script, ensuring smooth execution across all OUs.

## Prerequisites

Before using the script, ensure the following:

1. **PowerShell Modules:**
   - `ActiveDirectory`: For querying AD organizational units.
   - `LAPS` (Local Administrator Password Solution): For querying LAPS permissions.
   - `ImportExcel`: To export results to Excel.

   You can install the modules via PowerShell with:
   ```
   Install-Module -Name ActiveDirectory
   Install-Module -Name LAPS
   Install-Module -Name ImportExcel
   ```
   
2. **Required Permissions:**
   - The account running the script must have sufficient privileges to query AD objects and LAPS extended rights in Active Directory.

3. **Ensure LAPS is Deployed:**
   - The script assumes that Microsoft LAPS is installed and deployed within your environment.

## How to Use

1. **Clone the Repository:**

   First, clone this GitHub repository:
   ```git clone https://github.com/your-username/CreepCatcher-LAPS.git```
   
2. **Run the Script:**

   Open a PowerShell terminal and run the script:
   ```powershell .\CreepCatcher-LAPS.ps1```

The script will:
- Retrieve all top-level OUs from Active Directory.
- Query for LAPS extended rights (`Find-AdmPwdExtendedRights`) for each OU.
- Export the results to `Hunting-LAPSPrivilegeCreep.xlsx` in the working directory.

## Thread Limit:

The script utilizes parallel processing to improve performance. By default, the thread limit is set to `2` to balance performance and system load. You can modify this value in the script by changing the `$ThreadLimit` variable.

## Error Handling:

If an error occurs, the script will continue processing the next OU and log any issues in the console. OUs without LAPS extended rights will be highlighted in yellow.

## Output

The script generates an Excel file named `Hunting-LAPSPrivilegeCreep.xlsx`. This file contains the following columns:

- `ObjectDN`: The distinguished name of the AD object (OU).
- `ExtendedRightHolders`: A comma-separated list of accounts that have extended rights to LAPS passwords.

## Notes

- **Thread Limit Caution:** Be cautious when setting the `$ThreadLimit` as querying AD across multiple threads can generate significant load on domain controllers. Ensure your environment can handle the increased traffic if you adjust this value.
- **Scope of Scan:** The script is designed to scan all top-level OUs by default. If you'd like to limit the scan to specific OUs, modify the filtering logic in the `$allOUs` section of the script.

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for more details.

   

   

