<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Portal.aspx.cs" Inherits="PrototypeDrilldown.Portal" %>

<%@ Register Assembly="Microsoft.ReportViewer.WebForms, Version=9.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a"
    Namespace="Microsoft.Reporting.WebForms" TagPrefix="rsweb" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title></title>
</head>
<body>
    <form runat="server" id="form1">
    <br />Current User Identity:&nbsp;<%=Context.User.Identity.Name.ToString() %><br />
    <br /><%=System.Threading.Thread.CurrentPrincipal.Identity.Name.ToString()%><br />
    <rsweb:ReportViewer ID="ProfitabilityChartReportViewer" runat="server" ProcessingMode="Remote" Height="400px"
        Width="95%">
    </rsweb:ReportViewer>
    </form>
</body>
</html>
