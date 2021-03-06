<%-- 
    Document   : check_out
    Created on : 2017/2/20, 下午 03:42:09
    Author     : Administrator
--%>
<%@page import="com.verygoodbook.entity.*"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%
    //當url路徑符合: /member/*.*
    String url = request.getRequestURI();
    Customer member = null;
    //System.out.println(url.indexOf("/member/*.*"));
    if (url.indexOf("/member/") >= 0) {
        //先在session檢查有無Customer或Customer子類別建立的物件，且attribute: "member"    
        member = (Customer) session.getAttribute("member");
        if (member == null) {
            //若無已登入的會員，redirect到login.jsp強迫先登入後才能繼續執行
            session.setAttribute("previous.page", url);
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }
    }

    ShoppingCart cart = (ShoppingCart) session.getAttribute("cart");

    if (cart == null || cart.isEmpty()) {
        response.sendRedirect(request.getContextPath() + "/cart.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>結帳作業</title>
        <%@include file="/WEB-INF/subviews/global_js.jsp" %>
    </head>
    <body>
        <jsp:include page="/WEB-INF/subviews/header.jsp" >
            <jsp:param name="subtitle" value="結帳作業"/>
        </jsp:include>
        <div id="article">
            <form action="check_out.do" method="POST">
            <table border='1'>
                <caption>購物車明細</caption>
                <thead>
                    <tr>
                        <th>No.</th><th>名稱</th><th>顏色</th><th>原價</th><th>折扣</th><th>售價</th><th>數量</th>
                    </tr>
                </thead>                    
                <tbody>
                    <% for (Product p : cart.getProductsSet()) {%>
                    <tr>
                        <td><%= p.getId()%></td><td><%= p.getName()%></td>
                        <td><%= p.getColor() == null ? "" : p.getColor()%></td>
                        <% if (p instanceof Book) {%>
                        <td><%= ((Book) p).getListPrice()%>元</td>
                        <%
                            int discount = (100 - ((Book) p).getDiscount());
                            if (discount % 10 == 0) {
                                discount /= 10;
                            }
                        %>
                        <td><%= discount%> 折</td>
                        <%} else {%>
                        <td></td><td></td>
                        <%}%>
                        <td><%= p.getUnitPrice()%></td>
                        <td><%= cart.getQuantity(p)%></td>                        
                    </tr>                    
                    <%}%>
                </tbody>
                <tfoot>
                    <% if ((member instanceof VIP)) {%>
                    <tr>
                        <td colspan="3">原來總金額:</td>
                        <td colspan="4"><%= cart.getTotalAmount()%></td>
                    </tr>
                    <tr>
                        <td colspan="3">VIP折扣:</td>
                        <td colspan="4"><%= ((VIP) member).getDiscount()%></td>
                    </tr>
                    <%}%>
                    <tr>
                        <td colspan="3">實際總金額:</td>
                        <td colspan="4"><%= cart.getVIPTotalAmount()%></td>
                    </tr>
                    <tr>
                        <td colspan="7">
                            <div style='width:45%;float: left;margin: 0'>
                            <label for='payment_type'>付款方式: </label>
                            <select id='payment_type' name='paymentType' required>
                                <option value=''>請選擇</option>
                                <% for(PaymentType pType:PaymentType.values()){%>
                                <option value='<%= pType.ordinal() %>'><%= pType %></option>
                                <%} %>
                            </select>
                            </div>
                            <div style='width:45%;float: right'>
                            <label for='shipping_type'>貨運方式: </label>
                            <select id='shipping_type' name='shippingType' required>
                                <option value=''>請選擇</option>
                                <% for(ShippingType sType:ShippingType.values()){%>
                                <option value='<%= sType.ordinal() %>'><%= sType %></option>
                                <%} %>
                                
                            </select>
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <td colspan="7">
                            <div style='width:45%;float: left;margin: 0'>
                                <fieldset>
                                    <legend>訂貨人</legend>
                                    <label for='name'>姓名: </label><input id='name' readonly value='${member.name}'><br>
                                    <label for='email'>電郵: </label><input id='email' readonly value='${member.email}'><br>
                                    <label for='phone'>電話: </label><input id='phone'  readonly value='${member.phone}'><br>
                                    <label for='address'>地址: </label><input id='address' value='${member.address}'><br>
                                </fieldset>
                            </div>
                            <div style='width:45%;float: right'>
                                <fieldset>
                                    <legend>收件人 <input type='button' value="複製" onclick="copyData()"></legend>
                                    <label for='receiver_name'>姓名: </label>
                                    <input id='receiver_name' name='name' required><br>
                                    <label for='receiver_email'>電郵: </label>
                                    <input id='receiver_email' name='email' required><br>
                                    <label for='receiver_phone'>電話: </label>
                                    <input id='receiver_phone' name='phone' required><br>
                                    <label for='receiver_address'>地址: </label>
                                    <input id='receiver_address' name='address' required><br>
                                </fieldset>
                                
                            </div>                            
                        </td>
                    </tr>
                </tfoot>
            </table>
            <input type='button' value="繼續購物" onclick="goShopping()">                
            <input type='submit' value="送出訂單">                
            </form>
        </div>
        <%@include  file="/WEB-INF/subviews/footer.jsp" %>        
    </body>
</html>
<script>
    function goShopping(){
        location.href="<%= request.getContextPath() %>/products_list.jsp";
    }
    
    function copyData(){
        $("#receiver_name").val($("#name").val());
        $("#receiver_email").val($("#email").val());
        $("#receiver_phone").val($("#phone").val());
        $("#receiver_address").val($("#address").val());
    }    
</script>
