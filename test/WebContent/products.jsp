<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
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
          <a class="brand" href="#">ShopStop</a>
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
              <% } %>
              <li class="active"><a href="/test/products.jsp">Products</a></li>
              <% if (session.getAttribute("role").equals("Customer")){ %>
              <li><a href="/test/shoppingcart.jsp">My Cart</a></li>
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
			if (request.getParameter("search") != null) session.setAttribute("search", request.getParameter("search"));
			
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
				if (session.getAttribute("role").equals("Owner")) {
					if (action != null && action.equals("insert")) {
						conn.setAutoCommit(false);
						pstmt = conn.prepareStatement(
						"INSERT INTO PRODUCTS (name, sku, cat, price) VALUES (?, ?, ?, ?)");
						pstmt.setString(1, request.getParameter("nam"));
						pstmt.setString(2, request.getParameter("sku"));
						
						// find category id
						PreparedStatement check2 = conn.prepareStatement(
		                		"SELECT * FROM CATEGORY WHERE nam='" +
		                		request.getParameter("category") + "'");
	            		check2.execute();
	            		ResultSet resultSet2 = check2.getResultSet(); //result set for records
						resultSet2.next();
						pstmt.setInt(3, resultSet2.getInt("id"));
	            				
						pstmt.setInt(4, Integer.parseInt(request.getParameter("price")));
						int rowCount = pstmt.executeUpdate();
						conn.commit();
						conn.setAutoCommit(true);
						response.sendRedirect("/test/products.jsp");
		            }
					if (action != null && action.equals("update")) {
						conn.setAutoCommit(false);
						pstmt = conn.prepareStatement(
								"UPDATE PRODUCTS SET name = ?, sku = ?, cat = ?, price = ? WHERE id = ?");
						pstmt.setString(1, request.getParameter("nam"));
						pstmt.setString(2, request.getParameter("sku"));

						// find category id
						PreparedStatement check3 = conn.prepareStatement(
		                		"SELECT * FROM CATEGORY WHERE nam='" +
		                		request.getParameter("category") + "'");
	            		check3.execute();
	            		ResultSet resultSet3 = check3.getResultSet(); //result set for records
						resultSet3.next();
						pstmt.setInt(3, resultSet3.getInt("id"));
						
						pstmt.setInt(4, Integer.parseInt(request.getParameter("price")));
						pstmt.setInt(5, Integer.parseInt(request.getParameter("id")));
						int rowCount = pstmt.executeUpdate();
						conn.commit();
						conn.setAutoCommit(true);
						response.sendRedirect("/test/products.jsp");
					}
		            if (action != null && action.equals("delete")) {
						conn.setAutoCommit(false);
						pstmt = conn.prepareStatement("DELETE FROM PRODUCTS WHERE id = ?");
						pstmt.setInt(1, Integer.parseInt(request.getParameter("id")));
						int rowCount = pstmt.executeUpdate();
						conn.commit();
						conn.setAutoCommit(true);
						response.sendRedirect("/test/products.jsp");
					}
		            PreparedStatement check5 = conn.prepareStatement(
	                		"SELECT * FROM CATEGORY");
		            check5.execute();
		            ResultSet resultSet5 = check5.getResultSet(); %>
		            <a href="products.jsp?category=all">All Products</a><br>
		    <%
		            while (resultSet5.next()) {
		            	String link = "products.jsp?category=" + resultSet5.getString("nam");
		            	out.println ("<a href=" + link + ">" + resultSet5.getString("nam") + "</a><br>");
		            }
		            
			%>
				<form action="products.jsp" method="POST">
					<input type="hidden" name="action" value="search" />
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
	
	            <tr>
	                <form action="products.jsp" method="POST">
	                    <input type="hidden" name="action" value="insert"/>
	                    <th>&nbsp;</th>
	                    <th><input value="" name="nam" size="10"/></th>
	                    <th><input value="" name="sku" size="15"/></th>
	                    <!-- <th><input value="" name="category" size="15"/></th> -->
	                    <th><select name="category">
	                    <% check5 = conn.prepareStatement("SELECT * FROM CATEGORY");
			               check5.execute();
	                       resultSet5 = check5.getResultSet(); 
	                       while (resultSet5.next()) {
	                       		out.println ("<option value>" + resultSet5.getString("nam") + "</option>");
	                       } %></th>
	                    <th><input value="" name="price" size="15"/></th>
	                    <th><input type="submit" value="Insert"/></th>
	                </form>
	            </tr>
			 <%
			// Iterate over the ResultSet
				while (rs.next()) {
		%>

		<tr>
			<form action="products.jsp" method="POST">
				<input type="hidden" name="action" value="update" />
				<input type="hidden" name="id" value="<%=rs.getInt("id")%>" />
				<td><%=rs.getInt("id")%></td>
				<td><input value="<%=rs.getString("name")%>" name="nam" size="15" /></td>
				<td><input value="<%=rs.getString("sku")%>" name="sku" size="15" /></td>
				<%	PreparedStatement check4 = conn.prepareStatement(
		        		"SELECT * FROM CATEGORY WHERE id='" +
		        		rs.getInt("cat") + "'");
					check4.execute();
					ResultSet resultSet4 = check4.getResultSet(); //result set for records
					resultSet4.next();
				%>
				<th><select name="category">
	            <% check5 = conn.prepareStatement("SELECT * FROM CATEGORY");
		               check5.execute();
                       resultSet5 = check5.getResultSet(); 
                       while (resultSet5.next()) {
                    	   if (resultSet5.getString("nam").equals(resultSet4.getString("nam")))
                       			out.println ("<option selected=\"selected\" value>" + resultSet5.getString("nam") + "</option>");
                    	   else
                    		    out.println ("<option value>" + resultSet5.getString("nam") + "</option>");
	             } %></th>
				<td><input value="<%=rs.getInt("price")%>" name="price" size="15" /></td>
		<%   if (resultSet4.getInt("own") == (Integer) session.getAttribute("userid")) { %>
				<td><input type="submit" value="Update"></td>
		<%   } %>
			</form>
			<form action="products.jsp" method="POST">
				<input type="hidden" name="action" value="delete" /> <input
					type="hidden" value="<%=rs.getInt("id")%>" name="id" />
		<%   if (resultSet4.getInt("own") == (Integer) session.getAttribute("userid")) { %>
				<td><input type="submit" value="Delete" /></td>
		<%   } %>
			</form>
		</tr>
		<%
			}
		%>
		</table>
		<%
				}
				else {
					rs = statement.executeQuery("SELECT * FROM cse135.PRODUCTS");
					while (rs.next()){
					%>
						<a href="/test/productview.jsp?id=<%=Integer.toString(rs.getInt("id"))%>"><%=rs.getString("name") %></a>
						<br>
					<% 
					}
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
			System.out.println ("also you suck?!?");
		}
	%>
</body>
</html>