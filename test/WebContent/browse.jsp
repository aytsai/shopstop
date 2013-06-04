<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>You shouldn't be here!</title>

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

<!-- Let's get some JQuery here -->
<script src="//ajax.googleapis.com/ajax/libs/jquery/1.9.1/jquery.min.js"></script>

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
              <li><a href="/test/analytics.jsp">Analytics</a></li>
              <% } %>
              <li><a href="/test/products.jsp">Products</a></li>
              <% if (session.getAttribute("role").equals("Customer")){ %>
              <li class="active"><a href="/test/browse.jsp">Browse</a></li>
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
		PreparedStatement pstmt = null;
		Statement statement = null;
		ResultSet rs = null;
		try {
			Class.forName("com.mysql.jdbc.Driver");
			conn = DriverManager.getConnection("jdbc:mysql://localhost/cse135?user=test&password=test");
			statement = conn.createStatement();
		    rs = statement.executeQuery("select * from cse135.PRODUCTS");
		    String action = request.getParameter("action");
		    
		    
		    session.setAttribute("category", "all");
			session.setAttribute("search", null);
			if (request.getParameter("category") != null) session.setAttribute("category", request.getParameter("category"));
			if (request.getParameter("nam") != null) session.setAttribute("search", request.getParameter("nam"));
			
			if (action != null && action.equals("search")) {
				session.setAttribute("search", request.getParameter("nam"));
			}
			
			if ((session.getAttribute("category") != null && !session.getAttribute("category").equals("all"))
					&& session.getAttribute("search") != null) {
				PreparedStatement check7 = conn.prepareStatement(
                		"SELECT * FROM CATEGORY WHERE nam='" + session.getAttribute("category") + "'");
				check7.execute();
        		ResultSet resultSet7 = check7.getResultSet(); //result set for records
				resultSet7.next();
				rs = statement.executeQuery("select * from cse135.PRODUCTS WHERE cat = '" +
						resultSet7.getString("id") + "' AND name = '" + session.getAttribute("search") + "'");
			}
			else if ((session.getAttribute("category") != null && !session.getAttribute("category").equals("all"))
						&& session.getAttribute("search") == null) {
				PreparedStatement check7 = conn.prepareStatement(
                		"SELECT * FROM CATEGORY WHERE nam='" + session.getAttribute("category") + "'");
				check7.execute();
        		ResultSet resultSet7 = check7.getResultSet(); //result set for records
				resultSet7.next();
				rs = statement.executeQuery("select * from cse135.PRODUCTS WHERE cat = '" +
					resultSet7.getString("id") + "'");
			}
			else if (session.getAttribute("category").equals("all") && session.getAttribute("search") != null) {
				rs = statement.executeQuery("select * from cse135.PRODUCTS WHERE name = '" +
						session.getAttribute("search") + "'");
			}
			else {
				rs = statement.executeQuery("select * from cse135.PRODUCTS");
			}
		    
		
		   	if (session.getAttribute("username") != null) {
				if (session.getAttribute("role").equals("Customer")) {
			PreparedStatement check5 = conn.prepareStatement(
	                		"SELECT * FROM CATEGORY");
		            check5.execute();
		            ResultSet resultSet5 = check5.getResultSet();
		    %>
		            <a href="browse.jsp?category=all">All Products</a><br>
		    <%
		            while (resultSet5.next()) {
		            	String link = "browse.jsp?category=" + resultSet5.getString("nam");
		            	if (session.getAttribute("search") != null) link += "&nam=" + session.getAttribute("search");
		            	out.println ("<a href=" + link + ">" + resultSet5.getString("nam") + "</a><br>");
		            }
		            
			%>
				<form action="browse.jsp" method="POST">
					<input type="hidden" name="action" value="search" />
					<input type="hidden" name="category" value="<%=session.getAttribute("category")%>" />
					<input value="" name="nam" size="10"/>
					<td><input type="submit" value="Search" /></td>
				</form>
			
				<table border="1">
	            <tr>
	                <th>ID</th>
	                <th>Name</th>
	                <th>SKU</th>
	                <th>Category</th>
	                <th>Price</th>
	            </tr>
			 <%
			// Iterate over the ResultSet
				while (rs.next()) {
		%>

		<tr>
				<input type="hidden" name="id" value="<%=rs.getInt("id")%>" />
				<td><%=rs.getInt("id")%></td>
				<td>
					<%  String link2 = "productview.jsp?id=" + rs.getString("id");
			        	out.println ("<a href=" + link2 + ">" + rs.getString("name") + "</a><br>");
					%>
				</td>
				<td><%=rs.getString("sku")%></td>
				<%	PreparedStatement check4 = conn.prepareStatement(
		        		"SELECT * FROM CATEGORY WHERE id='" +
		        		rs.getInt("cat") + "'");
					check4.execute();
					ResultSet resultSet4 = check4.getResultSet(); //result set for records
					resultSet4.next();
				%>
				<th><%=resultSet4.getString("nam")%></th>
				<td><%=rs.getInt("price")%></td>
		</tr>
		<%
			}
		%>
		</table>
			<%
				}
				else {
					out.println ("<div style=\"text-align:center;\">Sorry, you aren't a customer, so you can't access this page :3</div>");
					String s = "<br><img style=\"display:block;margin-left:auto;margin-right:auto\" src=\"https://dl.dropboxusercontent.com/u/76520097/cat.gif\" >";
					out.println(s);
				}
		   	}
		   	else {
		   		out.println ("Please log in.");
		   	}
			rs.close();
			statement.close();
			conn.close();
		} catch (Exception e) {
			System.out.println (e);
			System.out.println ("also you suck?!?!");
		}
	%>
	
	<!--  
	
	<p id="red">Redirecting you in 6 seconds</p>

	<script LANGUAGE="JavaScript">
	var t = setTimeout(function() {
		window.location = "/test/"
	}, 2000);</script>
	
	
	
	<script>$(document).ready(function(){
	 $("#red").hide();
	};)
	
	</script>
	-->

</body>
</html>