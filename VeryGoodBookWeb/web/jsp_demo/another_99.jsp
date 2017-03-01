<%-- 
    Document   : another_99
    Created on : 2017/2/20, 上午 10:29:33
    Author     : Administrator
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>99乘法表</title>
    </head>
    <body>
        <%!
            int k=200;//member variable, attribute
                    
            
            public void jspInit(){
                System.out.println("member k=" + this.k+"<BR>");
            }
        %>
        <h1>99乘法表</h1>
        <hr>
        <% 
            int k=100; //local variable 
            out.println("member k=" + this.k+"<BR>");
            out.println("local k=" + k);
        %>
        <table border="1" >
            <caption>99乘法表</caption>
            <% for(int i=1;i<10;i++){ %>
            <tr>
                <% for(int j=1;j<10;j++){ %>
                <td><%=i%> * <%=j%> = <%= i*j%></td>
                <% } %>
            </tr>
            <%}%>
        </table>
    </body>
</html>
