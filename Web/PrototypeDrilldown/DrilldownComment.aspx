<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="DrilldownComment.aspx.cs" Inherits="PrototypeDrilldown.DrilldownComment" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head runat="server">
    <title>Drilldown Comment</title>
    
    <style type="text/css">
    
        .tableMRIData { font-family: Verdana; font-size: 11px; border-collapse: collapse; margin-left: 40px;}
        .tdMRIDataHeader { background-color: #B2B2B2; font-weight: bold; border: solid 1px #D3D3D3; padding: 6px 14px 6px 14px; }
        
        .trMRIDataAlternateItem { background-color: #ECECEC; }
        .tdMRIDataItem {  border: solid 1px #D3D3D3; padding: 6px 14px 6px 14px; }
        .tdMRIDataDrilldownItem { text-align: center; }
  
    </style>  
    
</head>
<body>
    <form id="form1" runat="server">    
    <div>
        <div style="padding-bottom: 30px;">
            <span style="font-family: Verdana; color: #B2B2B2; font-size: 18px;" runat="server">
                Comment for Gl Account <asp:Literal ID="GlAccountLiteral" runat="server"></asp:Literal>  (<asp:Literal ID="ReportPeriodLiteral" runat="server"></asp:Literal>)
            </span>
        </div>
    
        <asp:TextBox ID="CommentTextBox" runat="server" style="height:100px; width:400px;"  Wrap="true" TextMode="MultiLine"></asp:TextBox> 
        <asp:Button id="SaveButton" runat="server" Text="Save" 
            onclick="SaveButton_Click" />
    </div>
    </form>
</body>
</html>
