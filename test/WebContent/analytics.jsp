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
		String link;
		Integer c;
		Integer r;
		try {
			Class.forName("com.mysql.jdbc.Driver");
			conn = DriverManager.getConnection("jdbc:mysql://localhost/cse135?user=test&password=test");
			statement = conn.createStatement();
			statement2 = conn.createStatement();
			statement3 = conn.createStatement();
			
			// get the row/col page here
			session.setAttribute("row", null);
			session.setAttribute("col", null);
			if (request.getParameter("row") != null) session.setAttribute("row", request.getParameter("row"));
			if (request.getParameter("col") != null) session.setAttribute("col", request.getParameter("col"));
			
			String st = "SELECT PRODUCTS.name, PRODUCTS.id, PRODUCTS.price " +
                    "FROM PURCHASES LEFT JOIN PRODUCTS ON PRODUCTS.id = PURCHASES.product " +
					"GROUP BY PRODUCTS.id ORDER BY SUM(amount) DESC LIMIT 10";
					// "OFFSET " + Integer.parseInt(session.getAttribute("col").toString())*10
			rs = statement.executeQuery(st);
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
						"GROUP BY USERS.id ORDER BY SUM(amount*price) DESC LIMIT 10");
              // + "LIMIT 10" OFFSET " + (((Integer) session.getAttribute("row"))*10)
                while (rs2.next()) {
                	if ((rs2.getString("role")).equals("Customer")) {
                	rs = statement.executeQuery(st);
                %>
                	<tr><td><b>Name: <%= rs2.getString("nam") %></b><br>
                	        Age: <%= rs2.getString("age") %><br>
                	        State: <%= rs2.getString("sta") %><br></td><%
                	while (rs.next()) {
                		rs3 = statement3.executeQuery("SELECT COUNT(PURCHASES.amount), SUM(PURCHASES.amount)" +
                									  "FROM PURCHASES WHERE PURCHASES.customer = '"
                				                      + rs2.getString("id") + "' AND PURCHASES.product = '"
                				                      + rs.getString("id") + "' GROUP BY PURCHASES.product");
                		if (rs3.next()) {
                	%>
                		<td>Orders: <%= rs3.getString(1) %><br>
                		    Value: $<%= rs3.getInt(2)*rs.getInt("price") %></td>
                	<%
                		}
                		else {%><td>No records found.</td><%}
                	}
                	%></tr><%
                }
                }
                 	%>
              </tbody>
            </table>
			</div>
			<div class="span2">
			<br><br><br><br><br><br><br><br>
			<% if (session.getAttribute("row") == null || session.getAttribute("row").equals("0")) r = 0;
			   else r = Integer.parseInt(session.getAttribute("row").toString()) - 1;
			   link = "analytics.jsp?row=" + r;
		       if (session.getAttribute("col") != null) link += "&col=" + session.getAttribute("col");
		       out.println ("<a href=" + link + ">Prev</a><br>");
		    %>
			<br><br>
			Showing rows 1 - 10
			<br><br>
			<% if (session.getAttribute("row") == null) r = 1;
			   else r = Integer.parseInt(session.getAttribute("row").toString()) + 1;
			   link = "analytics.jsp?row=" + r;
		       if (session.getAttribute("col") != null) link += "&col=" + session.getAttribute("col");
		       out.println ("<a href=" + link + ">Next</a><br>");
		    %>
			</div>
			<div class="row">
			<div class="span1 offset3">
			<% if (session.getAttribute("col") == null || session.getAttribute("col").equals("0")) c = 0;
			   else c = Integer.parseInt(session.getAttribute("col").toString()) - 1;
			   link = "analytics.jsp?col=" + c;
		       if (session.getAttribute("row") != null) link += "&row=" + session.getAttribute("row");
		       out.println ("<a href=" + link + ">Prev</a><br>");
		    %>
			</div>
			<div class="span2">
			Showing cols 1-10
			</div>
			<div class="span1 offset1">
			<% if (session.getAttribute("col") == null) c = 1;
			   else c = Integer.parseInt(session.getAttribute("col").toString()) + 1;
			   link = "analytics.jsp?col=" + c;
		       if (session.getAttribute("row") != null) link += "&row=" + session.getAttribute("row");
		       out.println ("<a href=" + link + ">Next</a><br>");
		    %>
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
			System.out.println ("also you suck???!!?");
		}
	%>
  </body>
</html>