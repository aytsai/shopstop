<%@page import="java.sql.*, java.util.*, org.json.simple.JSONObject" %>

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
						
						check2 = conn.prepareStatement("SELECT * FROM PRODUCTS WHERE sku='" 
													+ request.getParameter("sku") + "'");
						check2.execute();
						resultSet2 = check2.getResultSet();
						resultSet2.next();
						
						JSONObject result = new JSONObject();
						result.put("success", true);
						result.put("id", resultSet2.getInt("id"));
						result.put("nam", request.getParameter("nam"));
						result.put("sku", request.getParameter("sku"));
						result.put("category", request.getParameter("category"));
						result.put("price", request.getParameter("price"));
						out.print(result);
						out.flush();
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
						JSONObject result = new JSONObject();
						result.put("success", true);
						out.print(result);
						out.flush();
					}
					if (action != null && action.equals("delete")) {
						conn.setAutoCommit(false);
						pstmt = conn.prepareStatement("DELETE FROM PRODUCTS WHERE id = ?");
						pstmt.setInt(1, Integer.parseInt(request.getParameter("id")));
						int rowCount = pstmt.executeUpdate();
						conn.commit();
						conn.setAutoCommit(true);
						JSONObject result = new JSONObject();
						result.put("success", true);
						out.print(result);
						out.flush();
					}
				}
		   	}
		   	rs.close();
			statement.close();
			conn.close();
		} catch (Exception e) {
			System.out.println (e);
			System.out.println ("also you suck?!?");
		}
		
		            %>