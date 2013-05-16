<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="utf-8">
<title>Sign up &middot; ShopStop</title>
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<meta name="description" content="">
<meta name="author" content="">

<!-- Le styles -->
<link href="./css/bootstrap.css" rel="stylesheet">
<style type="text/css">
body {
	padding-top: 40px;
	padding-bottom: 40px;
	background-color: #f5f5f5;
}

.form-signin {
	max-width: 300px;
	padding: 19px 29px 29px;
	margin: 0 auto 20px;
	background-color: #fff;
	border: 1px solid #e5e5e5;
	-webkit-border-radius: 5px;
	-moz-border-radius: 5px;
	border-radius: 5px;
	-webkit-box-shadow: 0 1px 2px rgba(0, 0, 0, .05);
	-moz-box-shadow: 0 1px 2px rgba(0, 0, 0, .05);
	box-shadow: 0 1px 2px rgba(0, 0, 0, .05);
}

.form-signin .form-signin-heading,.form-signin .checkbox {
	margin-bottom: 10px;
}

.form-signin input[type="text"],.form-signin input[type="password"] {
	font-size: 16px;
	height: auto;
	margin-bottom: 15px;
	padding: 7px 9px;
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
              <li class="active"><a href="/test/signup.jsp">Sign Up</a></li>
              <% if (session.getAttribute("username") != null){ %>
              <% if (session.getAttribute("role").equals("Owner")){ %>
              <li><a href="/test/category.jsp">Categories</a></li>
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
    
    <br>
    <br>


	<div class="container">
		<%-- Import the java.sql package --%>
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
		    rs = statement.executeQuery("select * from cse135.USERS");
		    String action = request.getParameter("action");
		    boolean recordFound = false;
		    
		    // insertion
		    if (action != null && action.equals("insert")) {
                conn.setAutoCommit(false);
                conn.setAutoCommit(false);
                PreparedStatement check = null;
                // check for duplicate name
                check = conn.prepareStatement("SELECT * FROM cse135.USERS WHERE nam='" +
                		request.getParameter("nam") + "'");
                check.execute();
                ResultSet resultSet = check.getResultSet(); //result set for records
				recordFound = resultSet.next();
                if (recordFound == false) {
	                pstmt = conn.prepareStatement("INSERT INTO USERS (nam, role, age, sta) VALUES (?, ?, ?, ?)");
	                pstmt.setString(1, request.getParameter("nam"));
	                pstmt.setString(2, request.getParameter("role"));
	                pstmt.setInt(3, Integer.parseInt(request.getParameter("age")));
	                pstmt.setString(4, request.getParameter("sta"));
	                int rowCount = pstmt.executeUpdate();
	                conn.commit();
	                conn.setAutoCommit(true);
	                response.sendRedirect("/test/signin.jsp");
                }
            }
		 %>
		<form class="form-signin" action="signup.jsp" method="POST">

			<%     if (recordFound == true) out.println ("This username is already taken!");
			       if (session.getAttribute("username") != null) {
			    	out.println ("You're already signed in, " + session.getAttribute("username") + ".");
			    	out.println ("Are you trying to create another account?");
			       }
				   else{
				    out.println("<h2 class='form-signin-heading'>New Account</h2>");
				   }%>
			<input type="hidden" name="action" value="insert" /> <input
				type="text" class="input-block-level" name="nam" placeholder="Name">
			<select name="role">
				<option value="Owner">Owner</option>
				<option value="Customer">Customer</option>
			</select> <input type="text" class="input-block-level" name="age"
				placeholder="Age"> <select name="sta">
				<option value="AL">Alabama</option>
				<option value="AK">Alaska</option>
				<option value="AZ">Arizona</option>
				<option value="AR">Arkansas</option>
				<option value="CA">California</option>
				<option value="CO">Colorado</option>
				<option value="CT">Connecticut</option>
				<option value="DE">Delaware</option>
				<option value="DC">District Of Columbia</option>
				<option value="FL">Florida</option>
				<option value="GA">Georgia</option>
				<option value="HI">Hawaii</option>
				<option value="ID">Idaho</option>
				<option value="IL">Illinois</option>
				<option value="IN">Indiana</option>
				<option value="IA">Iowa</option>
				<option value="KS">Kansas</option>
				<option value="KY">Kentucky</option>
				<option value="LA">Louisiana</option>
				<option value="ME">Maine</option>
				<option value="MD">Maryland</option>
				<option value="MA">Massachusetts</option>
				<option value="MI">Michigan</option>
				<option value="MN">Minnesota</option>
				<option value="MS">Mississippi</option>
				<option value="MO">Missouri</option>
				<option value="MT">Montana</option>
				<option value="NE">Nebraska</option>
				<option value="NV">Nevada</option>
				<option value="NH">New Hampshire</option>
				<option value="NJ">New Jersey</option>
				<option value="NM">New Mexico</option>
				<option value="NY">New York</option>
				<option value="NC">North Carolina</option>
				<option value="ND">North Dakota</option>
				<option value="OH">Ohio</option>
				<option value="OK">Oklahoma</option>
				<option value="OR">Oregon</option>
				<option value="PA">Pennsylvania</option>
				<option value="RI">Rhode Island</option>
				<option value="SC">South Carolina</option>
				<option value="SD">South Dakota</option>
				<option value="TN">Tennessee</option>
				<option value="TX">Texas</option>
				<option value="UT">Utah</option>
				<option value="VT">Vermont</option>
				<option value="VA">Virginia</option>
				<option value="WA">Washington</option>
				<option value="WV">West Virginia</option>
				<option value="WI">Wisconsin</option>
				<option value="WY">Wyoming</option>
			</select>
			<button class="btn btn-large btn-primary" type="submit">Sign
				up</button>
			Already have an account? <a href="/test/signin.jsp">Sign in here.</a>
		</form>
		<%-- -------- Close Connection Code -------- --%>
		<%
				rs.close();
				statement.close();
				conn.close();
		} catch (Exception e) {
			System.out.println (e);
			System.out.println ("also you suck?!?!");
		} finally {
			if (rs != null) {
				try {
					rs.close();
				} catch (SQLException e) {
				}
				rs = null;
			}
			if (pstmt != null) {
				try {
					pstmt.close();
				} catch (SQLException e) {
				}
				pstmt = null;
			}
			if (conn != null) {
				try {
					conn.close();
				} catch (SQLException e) {
				} // Ignore
				conn = null;
			}
		}
	%>

	</div>
	<!-- /container -->

</body>
</html>