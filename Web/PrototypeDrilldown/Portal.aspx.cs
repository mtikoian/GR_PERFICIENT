using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Microsoft.Reporting.WebForms;
using System.Configuration;
using System.Net;

namespace PrototypeDrilldown
{
    public partial class Portal : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!this.IsPostBack)
            {

                //ProfitabilityChartReportViewer.Reset();
                ProfitabilityChartReportViewer.ShowExportControls = false;
                ProfitabilityChartReportViewer.ShowFindControls = false;
                ProfitabilityChartReportViewer.ShowParameterPrompts = false;
                ProfitabilityChartReportViewer.ShowRefreshButton = false;
                ProfitabilityChartReportViewer.ShowToolBar = false;
                ProfitabilityChartReportViewer.ShowZoomControl = false;
                ProfitabilityChartReportViewer.ServerReport.ReportPath = "/Profitability Chart";
                ProfitabilityChartReportViewer.ServerReport.ReportServerUrl = new Uri(ConfigurationSettings.AppSettings["ReportServerUrl"]);
                ProfitabilityChartReportViewer.ProcessingMode = ProcessingMode.Remote;

            }
            else
            {
                ProfitabilityChartReportViewer.ShowToolBar = true;
                ProfitabilityChartReportViewer.ShowExportControls = true;
                ProfitabilityChartReportViewer.ShowPageNavigationControls = true;
            }
            
        }
    }
}
