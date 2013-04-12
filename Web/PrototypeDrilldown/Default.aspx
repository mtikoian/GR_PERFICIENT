<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="PrototypeDrilldown._Default" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head runat="server">
    <title>Warehouse Drilldown</title>
    
    <style type="text/css">
    
        .tableWarehouseData { font-family: Verdana; font-size: 11px; border-collapse: collapse; margin-left: 40px;}
        .tdWarehouseDataHeader { background-color: #B2B2B2; font-weight: bold; border: solid 1px #D3D3D3; padding: 6px 14px 6px 14px; }
        
        .trWarehouseDataAlternateItem { background-color: #ECECEC; }
        .tdWarehouseDataItem {  border: solid 1px #D3D3D3; padding: 6px 14px 6px 14px; }
        .tdWarehouseDataDrilldownItem { text-align: center;}
    
        a:link { color: #808080; text-decoration: none; font-weight: bold;}
        a:visited { color: #808080; text-decoration: none; font-weight: bold;}
        a.hover { color: #808080; text-decoration: underline; font-weight: bold;}
        a:active { color: #808080; text-decoration: none; font-weight: bold;}    
    
    </style>
    
</head>
<body>
    <form id="form1" runat="server">
    <div>        
        
        <div id="divHeader" style="padding-bottom: 30px;">
            <span id="spanHeader" style="font-family: Verdana; color: #B2B2B2; font-size: 18px;" runat="server">Drilldown for GL Account </span>
        </div>
        
        <div style="font-family: Verdana; font-size: 10px; color: #808080; font-weight: bold; padding-bottom: 14px; width: 400px; margin-left: 40px; ">Cube -> <div style="width: 150px; text-decoration: underline; display: inline;">Warehouse Data</div></div>
        
        <asp:Repeater ID="repeaterWarehouseData" runat="server">
        
            <HeaderTemplate>
        
                <table class="tableWarehouseData" cellpadding="0" cellspacing="0">
                    <tr>
                        <td class="tdWarehouseDataHeader">Drilldown</td>
                        <td class="tdWarehouseDataHeader">Gl Account Code</td>
                        <td class="tdWarehouseDataHeader">Gl Account Name</td>
                        <td class="tdWarehouseDataHeader">Local Actual <span style="font-size: 8px;">(USD)</span></td>
                    </tr>
            
            </HeaderTemplate>
        
            <ItemTemplate>
            
                    <tr class='<%# Container.ItemIndex % 2 == 0 ? "" : "trWarehouseDataAlternateItem" %>'>
                        <td class="tdWarehouseDataItem tdWarehouseDataDrilldownItem"><a href="DrilldownMRI.aspx?<%# DataBinder.Eval(Container.DataItem, "ReferenceCode") %>&sourcecode=<%# DataBinder.Eval(Container.DataItem, "SourceCode") %>&sourcetable=<%# DataBinder.Eval(Container.DataItem, "SourceTable") %>">MRI</a></td>
                        <td class="tdWarehouseDataItem"><%# DataBinder.Eval(Container.DataItem, "GlAccountCode") %></td>
                        <td class="tdWarehouseDataItem"><%# DataBinder.Eval(Container.DataItem, "GlAccountName")%></td>
                        <td class="tdWarehouseDataItem"><%# string.Format("{0:##,##0.00;(##,##0.00)}", DataBinder.Eval(Container.DataItem, "LocalActual"))%></td>
                    </tr>
            
            </ItemTemplate>
        
            <FooterTemplate>
            
                </table>
            
            </FooterTemplate>
        
        </asp:Repeater>
        
    </div>
    </form>
</body>
</html>
