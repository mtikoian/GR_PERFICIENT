using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Data.SqlClient;

namespace PrototypeDrilldown
{
    public partial class _Default : System.Web.UI.Page
    {
        private string _glAccountCode;

        public string glAccountCode
        {
            get
            {   
                string temp = Request.QueryString["glaccountcode"];
                
                if (String.IsNullOrEmpty(temp))
                {
                    _glAccountCode =  String.Empty;
                }
                else
                {
                    _glAccountCode = temp;
                }                
                
                return _glAccountCode;
            }
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            spanHeader.InnerText = "Drilldown for GL Account " + glAccountCode;

            DataSet resultDataSet = getWarehouseData();
            repeaterWarehouseData.EnableViewState = false;

            if (resultDataSet.Tables.Count > 0 & resultDataSet.Tables.Contains("warehouseData")) // if a datatable within this dataset was populated with data from the database query
            {
                repeaterWarehouseData.DataSource = resultDataSet.Tables["warehouseData"];
                repeaterWarehouseData.DataBind();
            }
        }

        private DataSet getWarehouseData()
        {
            DataSet resultDataSet = new DataSet();

            if (!String.IsNullOrEmpty(glAccountCode))
            {
                string databaseQuery = @"SELECT GLAC.GlAccountCode, GLAC.GlAccountName, PA.LocalActual, REPLACE(PA.ReferenceCode, ' ', '') AS ReferenceCode, S.SourceCode, PAST.SourceTable FROM dbo.ProfitabilityActual AS PA INNER JOIN dbo.GlAccount AS GLAC ON PA.GlAccountKey = GLAC.GlAccountKey INNER JOIN dbo.Calendar AS C ON C.CalendarKey = PA.CalendarKey INNER JOIN dbo.ExchangeRate AS ER ON PA.CalendarKey = ER.CalendarKey AND PA.LocalCurrencyKey = ER.SourceCurrencyKey AND ER.DestinationCurrencyKey = 2 INNER JOIN dbo.[Source] AS S ON PA.SourceKey = S.SourceKey INNER JOIN dbo.ProfitabilityActualSourceTable AS PAST ON PA.ProfitabilityActualSourceTableId = PAST.ProfitabilityActualSourceTableId	WHERE GLAC.GlAccountCode = '" + glAccountCode + "' AND C.CalendarPeriod IN (201001, 201002, 201003, 201004, 201005)";
                string databaseConnectionString = @"Data Source=BISQLDEV;user id=CDTSTAGING;password=Sqlst@ging;Initial Catalog=GrReporting";
                SqlConnection databaseConnection = new SqlConnection(databaseConnectionString);
                
                try
                {
                    databaseConnection.Open();
                    SqlDataAdapter dataAdapter = new SqlDataAdapter(databaseQuery, databaseConnection);                    
                    dataAdapter.Fill(resultDataSet, "warehouseData");
                }
                catch (SqlException e)
                {
                }
                finally
                {
                    databaseConnection.Close();
                }                
            }

            return resultDataSet;
        }

    }
}
