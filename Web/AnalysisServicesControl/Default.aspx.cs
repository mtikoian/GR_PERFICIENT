using System;
using System.Collections.Generic;
using System.Linq;
using System.Data;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Microsoft.AnalysisServices.AdomdClient;
using System.Configuration;

namespace ClearCubeCache
{
    public partial class _Default : System.Web.UI.Page
    {
        #region Events

        protected void Page_Load(object sender, EventArgs e)
        {
            Response.Cache.SetCacheability(HttpCacheability.NoCache); // set cache = false
        }

        protected void ClearCacheButton_Click(object sender, EventArgs e)
        {
            string cacheClearedString = ClearCubeCache();

            if (cacheClearedString == String.Empty)
            {
                ClearCacheStatusLabel.Style.Add("color", "");
                ClearCacheStatusLabel.InnerText = "Cube cache cleared successfully";
            }
            else
            {
                ClearCacheStatusLabel.Style.Add("color", "red");
                ClearCacheStatusLabel.InnerText = "Clearing of cube cache failed: " + System.Environment.NewLine + cacheClearedString;
            }

        }

        #endregion

        #region Methods

        private string ClearCubeCache()
        {
            string cacheCleared = String.Empty; // an empty string will be returned if the method executes successfully, else the exception text will be returned for display
            AdomdConnection cubeConnection = new AdomdConnection();
            try
            {
                cubeConnection.ConnectionString = ConfigurationManager.ConnectionStrings["GrReportingCube"].ConnectionString;

                cubeConnection.Open();
                AdomdCommand cubeCommand = cubeConnection.CreateCommand();
                cubeCommand.CommandType = CommandType.Text;
                cubeCommand.CommandText = String.Format(@"<Batch xmlns=""http://schemas.microsoft.com/analysisservices/2003/engine"">
                                          <ClearCache>
                                            <Object>
                                              <DatabaseID>{0}</DatabaseID>
                                            </Object>
                                          </ClearCache>
                                        </Batch>", cubeConnection.Database);

                cubeCommand.Execute();
            }
            catch (Exception exception)
            {
                cacheCleared = exception.ToString();
            }
            finally
            {
                if (cubeConnection.State == ConnectionState.Open)
                {
                    cubeConnection.Close();
                }

                cubeConnection.Dispose();
            }

            return cacheCleared;
        }

        #endregion
    }
}
