<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="Default" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Home</title>
    <telerik:RadStyleSheetManager ID="RadStyleSheetManager1" runat="server" />
    <link rel="shortcut icon" type="image/x-icon" href="images/patient.png" />
    <style type="text/css">
        .size-custom {
            width: 569px;
            margin: 0 8px 0 0;
            margin: auto;
        }

        .login-form-container fieldset {
            width: 650px;
            background: url(images/fldBgr.gif) repeat-x #a0b3be;
            padding: 0 10px 40px 0;
        }

        .profileData {
            display: inline-block;
            zoom: 1;
            *display: inline;
            vertical-align: top;
        }

        .profile-img {
            margin: 30px 30px 0 20px;
        }

        .profileData {
            width: 450px;
            padding: 40px 0 0;
        }

            .profileData h3 {
                font-size: 36px;
                color: #647d8e;
                font-weight: normal;
                margin: 0 0 25px 0;
                padding: 0 0 5px 0;
                background: url(images/h3bgr.png) left bottom repeat-x;
            }

            .profileData .inputWrapper {
                text-align: right;
                margin: 0 0 10px 0;
            }

        .clearer {
            height: 1px;
            margin-top: -1px;
            clear: both;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <telerik:RadScriptManager ID="RadScriptManager1" runat="server">
            <Scripts>
                <asp:ScriptReference Assembly="Telerik.Web.UI" Name="Telerik.Web.UI.Common.Core.js" />
                <asp:ScriptReference Assembly="Telerik.Web.UI" Name="Telerik.Web.UI.Common.jQuery.js" />
                <asp:ScriptReference Assembly="Telerik.Web.UI" Name="Telerik.Web.UI.Common.jQueryInclude.js" />
            </Scripts>
        </telerik:RadScriptManager>
        <script type="text/javascript">
        //Put your JavaScript code here.
        </script>
        <telerik:RadAjaxManager ID="RadAjaxManager1" runat="server">
        </telerik:RadAjaxManager>
        <telerik:RadFormDecorator RenderMode="Lightweight" Skin="Silk" ID="FormDecorator1" runat="server" DecoratedControls="All" ControlsToSkip="Zone" />
        <div runat="server" id="LoginFormContainer" class="login-form-container">
            <fieldset style="margin: auto">
                <img src="~/images/profileImg.png" runat="server" id="ProfilePhoto" alt="Profile image" class="profile-img" />
                <div class="profileData">
                    <h3>Login</h3>
                    <div class="inputWrapper">
                        <label for="userName">
                            Username:
                        </label>
                        <input type="text" id="UserName" runat="server"/>
                        <asp:RequiredFieldValidator ID="UserNameRequired" runat="server" ControlToValidate="UserName"
                            ErrorMessage="Username is required." ToolTip="Username is required."></asp:RequiredFieldValidator>
                 
                    </div>
                    <div class="inputWrapper">
                        <label for="password">
                            Password:
                        </label>
                        <input type="password" id="Password" runat="server" />
                        <asp:RequiredFieldValidator ID="PasswordRequired" runat="server" ControlToValidate="Password"
                            ErrorMessage="Password is required." ToolTip="Password is required."></asp:RequiredFieldValidator>
                    </div>

                    <div class="inputWrapper">
                        <asp:Button ID="sbmt" runat="server" Text="Submit" CausesValidation="true" />
                    </div>
                </div>
            </fieldset>
        </div>
    </form>
</body>
</html>
