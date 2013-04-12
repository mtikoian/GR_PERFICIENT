using System;
using System.Collections.Generic;
using System.Text;
using Microsoft.AnalysisServices;
using System.Data;
using System.Data.Sql;
using System.Data.SqlClient;
using Microsoft.AnalysisServices.AdomdServer;
using System.Configuration;

public class CubeSecurity
{
    #region Private

    private string _UserName;

    #endregion

    #region Properties

    public string UserName
    {
        get
        {
            if (_UserName == null)
            {
                try
                {
                    _UserName = (new Expression("UserName ()").Calculate(null)).ToString(); // get the username of the user is using to access SSAS
                    _UserName = _UserName.Replace(@"\\", @"\"); // the UserName () SSAS function returns the username in the form DOMAIN\\USERNAME, replace the double \\ with a single \ for GACS compatibility
                }
                catch (Exception e)
                {
                    _UserName = String.Empty;
                }
            }

            return _UserName;
        }
    }

    #endregion

    #region Methods

    public Set GetFunctionalDepartmentSetByUser()
    {
        SetBuilder sb = new SetBuilder();

        try
        {
            DataSet dsUsersFunctionalDepartments = GetGACSFunctionDepartmentsByUser();

            if (dsUsersFunctionalDepartments.Tables.Count == 1) // if the dataset is populated with one datatable (which should be the case)
            {
                DataTable dtUsersFunctionalDepartments = dsUsersFunctionalDepartments.Tables[0];

                foreach (DataRow row in dtUsersFunctionalDepartments.Rows) // loop through each functional department returned by GACS
                {
                    MemberCollection members = Context.CurrentCube.Dimensions["Functional Department"].Hierarchies["Functional Department"].Levels[1].GetMembers(); // Context.CurrentCube.Dimensions["Functional Department"].AttributeHierarchies["FunctionalDepartmentHierarchy"].Levels["FunctionalDepartment"].GetMembers();

                    foreach (Member m in members) // foreach functional department returned by the cube
                    {
                        if (String.Compare(row[0].ToString(), m.Name, true) == 0) // if CUBE.FunctionalDepartmentName = GACS.FunctionalDepartmentName
                        {
                            TupleBuilder tb = new TupleBuilder();
                            tb.Add(new Expression(string.Format(m.UniqueName)).CalculateMdxObject(null).ToMember());
                            sb.Add(tb.ToTuple());
                        }
                    }
                }
            }
        }
        catch (Exception e)
        {
            // because sb is outside the scope of the try statement, in the event of an exception an empty set should be returned, i.e.: no access to any functional departments
        }

        return sb.ToSet();
    }

    private DataSet GetGACSFunctionDepartmentsByUser()
    {
        string GACSConnectionString = ConfigurationManager.ConnectionStrings["GACS"].ConnectionString;
        string GACSQuery = @"SELECT DISTINCT FD.Name FROM GACS.dbo.Staff AS S INNER JOIN GACS.dbo.StaffFunctionalDepartment AS SFD ON S.StaffId = SFD.StaffId INNER JOIN GACS.dbo.FunctionalDepartment AS FD ON SFD.FunctionalDepartmentId = FD.FunctionalDepartmentId WHERE LOWER(S.NTLogin) = '" + UserName + "'";

        DataSet dsGACSFunctionalDepartments = new DataSet();
        SqlConnection GACSConnection = new SqlConnection(GACSConnectionString);

        try
        {
            GACSConnection.Open();
            SqlDataAdapter dataAdapter = new SqlDataAdapter(GACSQuery, GACSConnection);
            dataAdapter.Fill(dsGACSFunctionalDepartments, "FunctionalDepartment");
        }
        catch (SqlException e)
        {
        }
        finally
        {
            if (GACSConnection.State == ConnectionState.Open) // if the database connection is still open, close it
            {
                GACSConnection.Close();
            }

            GACSConnection.Dispose();
        }

        return dsGACSFunctionalDepartments;
    }

    #endregion
}
