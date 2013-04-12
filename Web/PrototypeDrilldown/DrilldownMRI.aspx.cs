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
    public partial class DrilldownMRI : System.Web.UI.Page
    {
        #region ClassVariables

        private string _period;
        private string _refe;
        private string _item;
        private string _siteid;
        private string _source;
        private string _sourceTable;
        private string _sourceCode;

        #endregion

        #region Getters

        public string period
        {
            get
            {
                string temp = Request.QueryString["PERIOD"];

                if (String.IsNullOrEmpty(temp))
                {
                    _period = String.Empty;
                }
                else
                {
                    _period = temp;
                }

                return _period;
            }
        }

        public string refe
        {
            get
            {
                string temp = Request.QueryString["REF"];

                if (String.IsNullOrEmpty(temp))
                {
                    _refe = String.Empty;
                }
                else
                {
                    _refe = temp;
                }

                return _refe;
            }
        }

        public string item
        {
            get
            {
                string temp = Request.QueryString["ITEM"];

                if (String.IsNullOrEmpty(temp))
                {
                    _item = String.Empty;
                }
                else
                {
                    _item = temp;
                }

                return _item;
            }
        }

        public string siteid
        {
            get
            {
                string temp = Request.QueryString["SITEID"];

                if (String.IsNullOrEmpty(temp))
                {
                    _siteid = String.Empty;
                }
                else
                {
                    _siteid = temp;
                }

                return _siteid;
            }
        }

        public string source
        {
            get
            {
                string temp = Request.QueryString["SOURCE"];

                if (String.IsNullOrEmpty(temp))
                {
                    _source = String.Empty;
                }
                else
                {
                    _source = temp;
                }

                return _source;
            }
        }

        public string sourceTable
        {
            get
            {
                string temp = Request.QueryString["sourcetable"];

                if (String.IsNullOrEmpty(temp))
                {
                    _sourceTable = String.Empty;
                }
                else
                {
                    _sourceTable = temp;
                }

                return _sourceTable;
            }
        }

        public string sourceCode
        {
            get
            {
                string temp = Request.QueryString["sourcecode"];

                if (String.IsNullOrEmpty(temp))
                {
                    _sourceCode = String.Empty;
                }
                else
                {
                    _sourceCode = temp;
                }

                return _sourceCode;
            }
        }

        #endregion

        protected void Page_Load(object sender, EventArgs e)
        {
            divMRI.InnerText += sourceCode;

            DataSet resultDataSet = getMRIData();
            repeaterMRIData.EnableViewState = false;

            if (resultDataSet.Tables.Count > 0 & resultDataSet.Tables.Contains("MRIData")) // if a datatable within this dataset was populated with data from the database query
            {
                repeaterMRIData.DataSource = resultDataSet.Tables["MRIData"];
                repeaterMRIData.DataBind();
            }
        }

        private DataSet getMRIData()
        {
            DataSet resultDataSet = new DataSet();

            if (!String.IsNullOrEmpty(period) & !String.IsNullOrEmpty(refe) & !String.IsNullOrEmpty(source) & !String.IsNullOrEmpty(siteid) & !String.IsNullOrEmpty(item) & !String.IsNullOrEmpty(sourceCode) & !String.IsNullOrEmpty(sourceTable))
            {
                string databaseQuery = @"DECLARE @SourceCode NVARCHAR(20) SET @SourceCode = '" + sourceCode + "' DECLARE @SourceDBase NVARCHAR(40) SET @SourceDBase = CASE WHEN @SourceCode = 'US' THEN 'US_PROP_TEST' WHEN @SourceCode = 'UC' THEN 'US_CORP_TEST' WHEN @SourceCode = 'EU' THEN 'MRI_PROP_TEST' WHEN @SourceCode = 'EC' THEN 'EU_CORP_TEST' WHEN @SourceCode = 'CN' THEN 'CN_PROP_TEST' WHEN @SourceCode = 'CC' THEN 'CN_CORP_TEST' WHEN @SourceCode = 'BR' THEN 'BR_PROP' WHEN @SourceCode = 'BC' THEN 'BR_CORP' WHEN @SourceCode = 'IN' THEN 'IN_PROP' WHEN @SourceCode = 'IC' THEN 'IN_CORP' ELSE '' END SET @SourceDBase = @SourceDBase + '.dbo.' DECLARE @Query NVARCHAR(MAX) SET @Query = 'SELECT PERIOD, REF, SOURCE, ACCTNUM, DEPARTMENT, JOBCODE, AMT, DESCRPN FROM ' + @SourceDBase + '" + sourceTable + "' + ' WHERE PERIOD=" + period + " AND REF=''" + refe + "'' AND [SOURCE]=''" + source + "'' AND SITEID=''" + siteid + "'' AND ITEM=''" + item + "''' EXEC(@Query)";
                string databaseConnectionString = @"Data Source=SQLSTAGE;user id=CDTSTAGING;password=Sqlst@ging;";
                SqlConnection databaseConnection = new SqlConnection(databaseConnectionString);

                try
                {
                    databaseConnection.Open();
                    SqlDataAdapter dataAdapter = new SqlDataAdapter(databaseQuery, databaseConnection);
                    dataAdapter.Fill(resultDataSet, "MRIData");
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
