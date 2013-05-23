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
              <li><a href="/test/analytics.jsp">Analytics</a></li>
              <% } %>
              <li class="active"><a href="/test/products.jsp">Products</a></li>
              <% if (session.getAttribute("role").equals("Customer")){ %>
              <li><a href="/test/browse.jsp">Browse</a></li>
              <% } %>
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
	PreparedStatement pstmt2 = null;
	Statement statement = null;
	ResultSet rs = null;
	ResultSet rs2 = null;
	ResultSet productName = null;
	try {
		Class.forName("com.mysql.jdbc.Driver");
		conn = DriverManager.getConnection("jdbc:mysql://localhost/cse135?user=test&password=test");
		statement = conn.createStatement();
	    rs = statement.executeQuery("select * from cse135.SHOPPINGCART WHERE customer = " +
											session.getAttribute("userid").toString());
	    String action = request.getParameter("action");
	
	   	if (session.getAttribute("username") != null) {
			if (session.getAttribute("role").equals("Customer")) {
				if (action != null && action.equals("add")) {
					conn.setAutoCommit(false);
					pstmt = conn.prepareStatement("INSERT INTO cse135.SHOPPINGCART (customer, product, amount) VALUES (?, ?, ?)");
					pstmt.setInt(1, Integer.parseInt(session.getAttribute("userid").toString()));
					pstmt.setInt(2, Integer.parseInt(request.getParameter("id")));
					pstmt.setInt(3, Integer.parseInt(request.getParameter("amount")));
					pstmt.executeUpdate();
					conn.commit();
					conn.setAutoCommit(true);
					response.sendRedirect("/test/shoppingcart.jsp");
				}
	            rs2 = statement.executeQuery("SELECT * FROM cse135.PRODUCTS WHERE id=" + 
												request.getParameter("id"));
	          	rs2.next();
	          	%>
	          	<h1><%=rs2.getString("name") %></h1>
	          	<p>Product costs: $<%=Integer.toString(rs2.getInt("price")) %></p>
	          	<p>SKU: <%=rs2.getString("sku") %></p>
	          	<p>
	          	
	          	<form action="productview.jsp" method="POST">
				<input type="hidden" name="action" value="add" />
				<input type="hidden" name="id" value="<%=Integer.toString(rs2.getInt("id")) %>" />
				Amount: <input value="" name="amount" size="15"/><P>
				<input type="submit" name="purchase" value="Add to Shopping Cart">
				</form>
	          	<% 
			}
			else {
				out.println ("Sorry, you aren't an customer, so you can't access this page.");
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