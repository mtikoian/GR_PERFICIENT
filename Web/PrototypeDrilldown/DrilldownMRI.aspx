<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="DrilldownMRI.aspx.cs" Inherits="PrototypeDrilldown.DrilldownMRI" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head runat="server">
    <title>MRI Drilldown</title>
    
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

        <div id="divHeader" style="padding-bottom: 30px;">
            <span id="spanHeader" style="font-family: Verdana; color: #B2B2B2; font-size: 18px;" runat="server">MRI Drilldown </span>
        </div>
        
        <div style="font-family: Verdana; font-size: 10px; color: #808080; font-weight: bold; padding-bottom: 14px; width: 400px; margin-left: 40px; ">Cube -> Data Warehouse -> <div id="divMRI" style="width: 150px; text-decoration: underline; display: inline;" runat="server">MRI:</div></div>
        
        <asp:Repeater ID="repeaterMRIData" runat="server">
        
            <HeaderTemplate>
        
                <table class="tableMRIData" cellpadding="0" cellspacing="0">
                    <tr>
                        <td class="tdMRIDataHeader">PERIOD</td>
                        <td class="tdMRIDataHeader">REF</td>
                        <td class="tdMRIDataHeader">SOURCE</td>
                        <td class="tdMRIDataHeader">ACCTNUM</td>
                        <td class="tdMRIDataHeader">DEPARTMENT</td>
                        <td class="tdMRIDataHeader">JOBCODE</td>
                        <td class="tdMRIDataHeader">AMT <span style="font-size: 8px;">(USD)</span></td>
                        <td class="tdMRIDataHeader">DESCRPN</td>
                    </tr>
            
            </HeaderTemplate>
        
            <ItemTemplate>
            
                    <tr class='<%# Container.ItemIndex % 2 == 0 ? "" : "trMRIDataAlternateItem" %>'>
                        <td class="tdMRIDataItem"><%# DataBinder.Eval(Container.DataItem, "PERIOD")%></td>
                        <td class="tdMRIDataItem"><%# DataBinder.Eval(Container.DataItem, "REF")%></td>
                        <td class="tdMRIDataItem"><%# DataBinder.Eval(Container.DataItem, "SOURCE")%></td>
                        <td class="tdMRIDataItem"><%# DataBinder.Eval(Container.DataItem, "ACCTNUM")%></td>
                        <td class="tdMRIDataItem"><%# DataBinder.Eval(Container.DataItem, "DEPARTMENT")%></td>
                        <td class="tdMRIDataItem"><%# DataBinder.Eval(Container.DataItem, "JOBCODE")%></td>
                        <td class="tdMRIDataItem"><%# string.Format("{0:##,##0.00;(##,##0.00)}", DataBinder.Eval(Container.DataItem, "AMT"))%></td>
                        <td class="tdMRIDataItem"><%# DataBinder.Eval(Container.DataItem, "DESCRPN")%></td>
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
