<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="ClearCubeCache._Default" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head runat="server">
    <title>Analysis Services Cube Commands</title>
</head>
<body>
    <form id="form1" runat="server">
    <div>
        <h1>Analysis Services Cube Command</h1>
        <div>
            <asp:Button runat="server" ID="ClearCacheButton" 
                onclick="ClearCacheButton_Click" Text="Clear Cache" />
        </div>
        <br />
        <div ID="ClearCacheStatusLabel" style="font-family: Verdana; font-size: 12px;" Text="ErrorLabel" runat="server" />
    </div>
    </form>
</body>
</html>
