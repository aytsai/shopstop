<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
    <meta charset="utf-8">
    <title>ShopStop - One Stop Shopping, For You!</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="description" content="">
    <meta name="author" content="">

    <!-- Le styles -->
    <link href="./css/bootstrap.css" rel="stylesheet">
    <style type="text/css">
      body {
        padding-top: 60px;
        padding-bottom: 40px;
      }
      .sidebar-nav {
        padding: 9px 0;
      }

      @media (max-width: 980px) {
        /* Enable use of floated navbar text */
        .navbar-text.pull-right {
          float: none;
          padding-left: 5px;
          padding-right: 5px;
        }
      }
    </style>
    <link href="./css/bootstrap-responsive.css" rel="stylesheet">

    <!-- HTML5 shim, for IE6-8 support of HTML5 elements -->
    <!--[if lt IE 9]>
      <script src="../assets/js/html5shiv.js"></script>
    <![endif]-->

</head>
<body>

    <div class="navbar navbar-inverse navbar-fixed-top">
      <div class="navbar-inner">
        <div class="container-fluid">
          <button type="button" class="btn btn-navbar" data-toggle="collapse" data-target=".nav-collapse">
            <span class="icon-bar"></span>
            <span class="icon-bar"></span>
            <span class="icon-bar"></span>
          </button>
          <a class="brand" href="/test/">ShopStop</a>
          <div class="nav-collapse collapse">
            <p class="navbar-text pull-right">
              <% if (session.getAttribute("username") != null) {
            	  out.print("Logged in as " + session.getAttribute("username") + " ");
    		      out.print("<a href='/test/signout.jsp'>Log out?</a>");
                }else
                  out.print("<a href='/test/signin.jsp'>Log in</a>");
    		%>
            </p>
            <ul class="nav">
              <li><a href="/test/">Home</a></li>
              <li><a href="/test/signup.jsp">Sign Up</a></li>
              <% if (session.getAttribute("role").equals("Owner")){ %>
              <li><a href="/test/category.jsp">Categories</a></li>
              <li><a href="/test/analytics.jsp">Analytics</a></li>
              <% } %>
              <li><a href="/test/products.jsp">Products</a></li>
              <% if (session.getAttribute("role").equals("Customer")){ %>
              <li><a href="/test/browse.jsp">Browse</a></li>
              <% } %>
              <li class="active"><a href="/test/shoppingcart.jsp">My Cart</a></li>
            </ul>
          </div><!--/.nav-collapse -->
        </div>
      </div>
    </div>



	<%@ page import="java.sql.*"%>
	<%
		Connection conn = null;
		PreparedStatement pstmt = null;
		PreparedStatement pstmt2 = null;
		Statement statement = null;
		ResultSet rs = null;
		ResultSet rs2 = null;
		ResultSet productName = null;
		int total = 0;
		boolean buying = false;
		try {
			Class.forName("com.mysql.jdbc.Driver");
			conn = DriverManager.getConnection("jdbc:mysql://localhost/cse135?user=test&password=test");
			statement = conn.createStatement();
		    rs = statement.executeQuery("select * from cse135.SHOPPINGCART WHERE customer = " +
												session.getAttribute("userid").toString());
		    String action = request.getParameter("action");
		
		   	if (session.getAttribute("username") != null) {
		   		pstmt2 = conn.prepareStatement("SELECT * FROM cse135.PRODUCTS WHERE id = ?");
				if (session.getAttribute("role").equals("Customer")) {
		            if (action != null && action.equals("delete")) {
						conn.setAutoCommit(false);
						pstmt = conn.prepareStatement("DELETE FROM SHOPPINGCART WHERE id = ?");
						pstmt.setInt(1, Integer.parseInt(request.getParameter("id")));
						int rowCount = pstmt.executeUpdate();
						conn.commit();
						conn.setAutoCommit(true);
						response.sendRedirect("/test/shoppingcart.jsp");
					}
		            if (action != null && action.equals("purchase")) {
						conn.setAutoCommit(false);
						pstmt = conn.prepareStatement("SELECT * FROM cse135.SHOPPINGCART WHERE customer = " + 
														session.getAttribute("userid").toString());
						pstmt.execute();
						rs2 = pstmt.getResultSet();
						while (rs2.next()){
							pstmt2 = conn.prepareStatement("INSERT INTO cse135.PURCHASES (customer, product, amount, creditcard) VALUES (?, ?, ?, ?) ");
							pstmt2.setInt(1, Integer.parseInt(session.getAttribute("userid").toString()));
							pstmt2.setInt(2, Integer.parseInt(rs2.getString("product")));
							pstmt2.setInt(3, Integer.parseInt(rs2.getString("amount")));
							pstmt2.setString(4, request.getParameter("creditcard"));
							pstmt2.executeUpdate();
						}
						conn.commit();
						conn.setAutoCommit(true);
						response.sendRedirect("/test/purchase.jsp");
					}
					%>
						<table border="1">
			            <tr>
			                <th>ID</th>
			                <th>Product</th>
			                <th>Amount</th>
			                <th>Total</th>
			            </tr>
			      <%
			// Iterate over the ResultSet
				while (rs.next()) {
					buying = true;
					pstmt2.setInt(1, Integer.parseInt(rs.getString("product")));
					pstmt2.execute();
					productName = pstmt2.getResultSet();
					productName.next();
		%>

		<tr>
			<form action="shoppingcart.jsp" method="POST">
				<input type="hidden" name="action" value="delete" />
				<input type="hidden" name="id" value="<%=rs.getInt("id")%>" />
				<td><%=rs.getInt("id")%></td>
				<%
					out.println("<td><input value='" + productName.getString("name") + "' name='nam' size='15' /></td>");
				%>
				
				<td><input value="<%=rs.getString("amount")%>" name="nam" size="15" /></td>
				<% int temp = Integer.parseInt(rs.getString("amount")) * Integer.parseInt(productName.getString("price"));
				   total += temp;%>
				<%
					out.println("<td><input value='" + temp + "' name='nam' size='15' /></td>");
				%>
				<%-- Button --%>
				<td><input type="submit" value="delete"></td>
			</form>
		</tr>
		<%
			}
			out.println ("Here is your total: " + total);
		%>
		</table>
		<%if (buying == true) { %>
		<form action="shoppingcart.jsp" method="POST">
			<input type="hidden" name="action" value="purchase" />
			<input type="text" value="Enter credit card number here" name ="creditcard" />
			<input type="submit" value="purchase">
		</form>
					<%
					}
				}
				else {
					out.println ("Sorry, you aren't an customer, so you can't access this page.");
				}
		   	}
		   	else {
		   		out.println ("Please log in.");
		   	}
			rs.close();
			productName.close();
			statement.close();
			conn.close();
		} catch (Exception e) {
			System.out.println (e);
			System.out.println ("also you suck?!!?!?!?!??!");
		}
	%>


</body>
</html>