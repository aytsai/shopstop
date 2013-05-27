<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
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
              <% if (session.getAttribute("username") != null){ %>
              <% if (session.getAttribute("role").equals("Owner")){ %>
              <li><a href="/test/category.jsp">Categories</a></li>
              <li class="active"><a href="/test/analytics.jsp">Analytics</a></li>
              <% } %>
              <li><a href="/test/products.jsp">Products</a></li>
              <% if (session.getAttribute("role").equals("Customer")){ %>
              <li><a href="/test/browse.jsp">Browse</a></li>
              <% } %>
              <% if (session.getAttribute("role").equals("Customer")){ %>
              <li><a href="/test/shoppingcart.jsp">My Cart</a></li>
              <% } %>
              <% } %>
            </ul>
          </div><!--/.nav-collapse -->
        </div>
      </div>
    </div>
    
    <%@ page import="java.sql.*"%>
	<%
		Connection conn = null;
		Statement statement = null;
		Statement statement2 = null;
		Statement statement3 = null;
		ResultSet rs = null;
		ResultSet rs2 = null;
		ResultSet rs3 = null;
		try {
			Class.forName("com.mysql.jdbc.Driver");
			conn = DriverManager.getConnection("jdbc:mysql://localhost/cse135?user=test&password=test");
			statement = conn.createStatement();
			statement2 = conn.createStatement();
			statement3 = conn.createStatement();
			// COUNT(DISTINCT PURCHASES(product, customer)),
			/*String st = "SELECT PURCHASES.*, PRODUCTS.*, USERS.* " +
					"FROM PURCHASES, PRODUCTS, USERS " +
					"WHERE USERS.role = 'customer' AND PRODUCTS.id = PURCHASES.product AND PURCHASES.customer = USERS.id " +
					"ORDER BY PURCHASES.amount AND PRODUCTS.name";*/
			rs = statement.executeQuery("SELECT PRODUCTS.name " +
					                    "FROM PURCHASES LEFT JOIN PRODUCTS ON PRODUCTS.id = PURCHASES.product " +
										"GROUP BY PRODUCTS.id ORDER BY SUM(amount) DESC");
			if (session.getAttribute("username") != null) {
			%>
				<form action="products.jsp" method="POST">
					<input type="hidden" name="action" value="search" />
					<input type="hidden" name="category" value="<%=session.getAttribute("category")%>" />
					<input value="" name="nam" size="10"/>
					<td><input type="submit" value="Search" /></td>
				</form>
    <div class="container">
    	  <div class="row">
    	  <div class="span10">
          <table class="table table-bordered table-hover">
              <thead>
                <tr>
                    <th></th>
                  <%
				while (rs.next()) {
					%>
					<th><%= rs.getString("name") %></th>
	            <%
            	}%>
                </tr>
              </thead>
              <tbody>
              <%
              	rs2 = statement2.executeQuery("SELECT USERS.*" +
	                    "FROM PURCHASES LEFT JOIN USERS ON USERS.id = PURCHASES.customer " +
              			"LEFT JOIN PRODUCTS ON PRODUCTS.id = PURCHASES.product " +
						"GROUP BY USERS.id ORDER BY SUM(amount*price) DESC");
                while (rs2.next()) {
                	rs = statement.executeQuery("SELECT PRODUCTS.name, PRODUCTS.id " +
    	                    "FROM PURCHASES LEFT JOIN PRODUCTS ON PRODUCTS.id = PURCHASES.product " +
    						"GROUP BY PRODUCTS.id ORDER BY SUM(amount) DESC");
                %>
                	<tr><td><%= rs2.getString("nam") %></td><%
                	while (rs.next()) {
                		rs3 = statement3.executeQuery("SELECT * FROM PURCHASES WHERE PURCHASES.customer = '"
                				                      + rs2.getString("id") + "' AND PURCHASES.product = '"
                				                      + rs.getString("id") + "'");
                		if (rs3.next()) {
                	%>
                		<td><%= rs3.getString("amount") %></td>
                	<%
                		}
                		else {%><td>No records found.</td><%}
                	}
                	%></tr><%
                }
                 	%>
              </tbody>
            </table>
			</div>
			<div class="span2">
			<br><br><br><br><br><br><br><br>
			<a href="/">Prev</a>
			<br><br>
			Showing rows 1 - 10
			<br><br>
			<a href="/">Next</a>
			</div>
			<div class="row">
			<div class="span1 offset3">
			<a href="/">Prev</a>
			</div>
			<div class="span2">
			Showing columns 1-10
			</div>
			<div class="span1 offset1">
			<a href="/">Next</a>
			</div>
			</div>
			</div>
 
      <hr>

      <footer>
        <p>&copy; ShopStop 2013</p>
      </footer>

    </div><!--/container-->

<%
			}
		   	else {
		   		out.println ("Please log in.");
		   	}
			rs.close();
			statement.close();
			conn.close();
		} catch (Exception e) {
			System.out.println (e);
			System.out.println ("also you suck???!?!??!?!!?");
		}
	%>
  </body>
</html>