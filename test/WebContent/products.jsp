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
              <li><a href="/test/category.jsp">Categories</a></li>
              <li class="active"><a href="/test/products.jsp">Products</a></li>
              <li><a href="/test/shoppingcart.jsp">My Cart</a></li>
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
		
		   	if (session.getAttribute("username") != null) {
		   		out.println ("Hello " + session.getAttribute("username"));
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
					}
		            if (action != null && action.equals("delete")) {
						conn.setAutoCommit(false);
						pstmt = conn.prepareStatement("DELETE FROM PRODUCTS WHERE id = ?");
						pstmt.setInt(1, Integer.parseInt(request.getParameter("id")));
						int rowCount = pstmt.executeUpdate();
						conn.commit();
						conn.setAutoCommit(true);
					}
			%>
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
	                    <th><input value="" name="category" size="15"/></th>
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
				<td><input value="<%=resultSet4.getString("nam")%>" name="category" size="15" /></td>
				<td><input value="<%=rs.getInt("price")%>" name="price" size="15" /></td>
				<%-- Button --%>
				<td><input type="submit" value="Update"></td>
			</form>
			<form action="products.jsp" method="POST">
				<input type="hidden" name="action" value="delete" /> <input
					type="hidden" value="<%=rs.getInt("id")%>" name="id" />
				<%-- Button --%>
				<td><input type="submit" value="Delete" /></td>
			</form>
		</tr>
		<%
			}
		%>
		</table>
		<%
				}
				else {
					out.println ("Sorry, you aren't an owner, so you can't access this page.");
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
			System.out.println ("also you suck?!?!?!?!?!?");
		}
	%>
</body>
</html>