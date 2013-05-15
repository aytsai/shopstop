<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
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
          <a class="brand" href="/index.jsp">ShopStop</a>
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
              <li class="active"><a href="/test/category.jsp">Categories</a></li>
              <li><a href="/test/products.jsp">Products</a></li>
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
		    rs = statement.executeQuery("select * from cse135.CATEGORY");
		    String action = request.getParameter("action");
		
		   	if (session.getAttribute("username") != null) {
		   		out.println ("Hello " + session.getAttribute("username"));
				if (session.getAttribute("role").equals("Owner")) {
					if (action != null && action.equals("insert")) {
						conn.setAutoCommit(false);
						pstmt = conn.prepareStatement(
						"INSERT INTO CATEGORY (nam, description, own) VALUES (?, ?, ?)");
						pstmt.setString(1, request.getParameter("nam"));
						pstmt.setString(2, request.getParameter("description"));
						pstmt.setInt(3, (Integer) session.getAttribute("userid"));
						int rowCount = pstmt.executeUpdate();
						conn.commit();
						conn.setAutoCommit(true);
						response.sendRedirect("/test/category.jsp");
		            }
					if (action != null && action.equals("update")) {
						conn.setAutoCommit(false);
						pstmt = conn.prepareStatement(
								"UPDATE CATEGORY SET nam = ?, description = ? WHERE id = ?");
						pstmt.setString(1, request.getParameter("nam"));
						pstmt.setString(2, request.getParameter("description"));
						pstmt.setInt(3, Integer.parseInt(request.getParameter("id")));
						int rowCount = pstmt.executeUpdate();
						conn.commit();
						conn.setAutoCommit(true);
						response.sendRedirect("/test/category.jsp");
					}
		            if (action != null && action.equals("delete")) {
		            	// does NOT have the product check yet
		            	// if there's a product referring to this category, there is no delete button
						conn.setAutoCommit(false);
						pstmt = conn.prepareStatement("DELETE FROM CATEGORY WHERE id = ?");
						pstmt.setInt(1, Integer.parseInt(request.getParameter("id")));
						int rowCount = pstmt.executeUpdate();
						conn.commit();
						conn.setAutoCommit(true);
						response.sendRedirect("/test/category.jsp");
					}
					%>
						<table border="1">
			            <tr>
			                <th>ID</th>
			                <th>Name</th>
			                <th>Description</th>
			            </tr>
		
			            <tr>
			                	<form action="category.jsp" method="POST">
									<input type="hidden" name="action" value="insert"/>
									<th>&nbsp;</th>
									<th><input value="" name="nam" size="15"/></th>
									<th><input value="" name="description" size="15"/></th>
									<th><input type="submit" value="Insert"/></th>
								</form>
			            </tr>
			      <%
			// Iterate over the ResultSet
				while (rs.next()) {
		%>

		<tr>
			<form action="category.jsp" method="POST">
				<input type="hidden" name="action" value="update" />
				<input type="hidden" name="id" value="<%=rs.getInt("id")%>" />
				<td><%=rs.getInt("id")%></td>
				<td><input value="<%=rs.getString("nam")%>" name="nam" size="15" /></td>
				<td><input value="<%=rs.getString("description")%>" name="description" size="15" /></td>
				<%-- Button --%>
		<%   if (rs.getInt("own") == (Integer) session.getAttribute("userid")) { %>
				<td><input type="submit" value="Update"></td>
		<%   } %>
			</form>
			<form action="category.jsp" method="POST">
				<input type="hidden" name="action" value="delete" /> <input
					type="hidden" value="<%=rs.getInt("id")%>" name="id" />
		<%   PreparedStatement check4 = conn.prepareStatement(
        		"SELECT * FROM PRODUCTS WHERE cat='" +
        		rs.getInt("id") + "'");
			 check4.execute();
			 ResultSet resultSet4 = check4.getResultSet(); //result set for records
			 
		
			 // checks to see if you have permissions to delete this item
			 if ((rs.getInt("own") == (Integer) session.getAttribute("userid")) &&
					 (resultSet4.next() == false)) { %>
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
			System.out.println ("also you suck?!?!");
		}
	%>
</body>
</html>