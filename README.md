# Kinaxis Power BI Custom Connector

This repository contains a Power BI custom connector for Kinaxis Maestro, enabling secure and automated data access using oAuth client credentials.
This connector will use Maestro API calls to retrieve data from a workbook/worksheet

## Features

- Connects Power BI to Kinaxis using Maestro's client credentials (no user interaction required)
- Retrieves an access token automatically
- Supports parameterized queries for company, workbook, and worksheet
- Supports paging (TODO)

## Getting Started

### Prerequisites

- [Power BI Desktop](https://powerbi.microsoft.com/desktop/)
- [Power Query SDK for Visual Studio](https://marketplace.visualstudio.com/items?itemName=PowerQuerySDKTeam.PowerQuerySDK)
- Kinaxis API credentials (`client_id`, `client_secret`, `client_url`)

### Setup

1. **Clone this repository**

2. **Add your credentials**
   - Place your `client_id`, `client_secret`, and `client_url` files in the root directory (these are ignored by git).

3. **Build the connector**
   - Open the project in Visual Studio or VS Code.
   - Build the project to generate the `.mez` file in the `bin\AnyCPU\Debug\` directory.

4. **Install the connector**
   - Copy the `.mez` file to your Power BI custom connectors folder:
     ```
     %USERPROFILE%\Documents\Power BI Desktop\Custom Connectors
     ```

5. **Enable custom connectors in Power BI Desktop**
   - Go to `File > Options and settings > Options > Security > Data Extensions`
   - Select **(Not Recommended) Allow any extension to load without validation**

6. **Restart Power BI Desktop** and connect using the Kinaxis connector.

## Usage

- When prompted, enter your Kinaxis API parameters (company, workbook, worksheet, etc.).
- The connector will automatically retrieve an access token and fetch data.

## Development

- Main connector logic is in `KinaxisPBIConnector.pq`
- Build configuration is in `KinaxisPBIConnector.proj`
- Icon and resource files are included for branding

## License

This project is licensed for internal use. Contact the repository owner for more information.

---