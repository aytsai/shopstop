<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">


<%@ page import="java.sql.*"%>
<%@ page import="java.util.HashMap"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="java.util.HashSet"%>
<%@ page import ="java.util.Iterator" %>
<%@ page import ="java.util.Arrays" %>
<%!

/**
 * Simple class to keep track fo States, categories, and their respective prices.
 *
 */
public static class Sta 
{
  /**
   * The title of the State.  e.g. "AL", "CA", "WA"
   */
  private String title;
  
  /**
   * Keeps track of the categories and cummulative prices
   */
  private HashMap<String, Integer> m = new HashMap<String, Integer>();

  /**
   * Constructor, takes a String title.
   * 
   * @param title The title to assign to this Sta object.
   */
  public Sta(String title)
  {
	 this.title = title; 
  }
  
  public void add(String cat, int price)
  {
	  Integer i;
	  if((i = m.get(cat)) != null)
		 m.put(cat, price + i.intValue());
	  else
		 m.put(cat, new Integer(price));
  }
  
  public int fetchPrice(String cat)
  {
	  Integer temp = m.get(cat);
	  return temp == null ? -1 : temp.intValue();
  }
  
  public String getTitle()
  {
	  return title;
  }
}
%>
<%!

public static class StaOrganizer
{
	  private HashMap<String, Sta> l = new HashMap<String, Sta>();
	  private HashSet<String> states = new HashSet<String>();
	  private HashSet<String> cats = new HashSet<String>();
	  
	  
	  public void add(String state, String cat, int price)
	  {
		  cats.add(cat);
		  
		  if(exists(state))
			  l.get(state).add(cat, price);
		  else
		  {
			  Sta t = new Sta(state);
			  t.add(cat, price);
			  l.put(state, t);
			  states.add(state);
		  }	  
	  }
	  
	  public int fetchPrice(String state, String cat)
	  {
		  return exists(state) ? l.get(state).fetchPrice(cat) : -1;
	  }
	  
	  private boolean exists(String state)
	  {
		 return l.get(state) == null ? false : true;
	  }
	  
	  
	  public String[] getCatList()
	  {
		  ArrayList<String> wl = new ArrayList<String>();
		  Iterator<String> cl = cats.iterator();
		  while(cl.hasNext())
			  wl.add(cl.next());
		  
		  String[] temp = wl.toArray(new String[0]);
		  Arrays.sort(temp);
		  return temp;
	  }
	  
	  public String[] getStateList()
	  {
		  ArrayList<String> wl = new ArrayList<String>();
		  Iterator<String> cl = states.iterator();
		  while(cl.hasNext())
			  wl.add(cl.next());
		  
		  String[] temp = wl.toArray(new String[0]);
		  Arrays.sort(temp);
		  return temp;
	  }
}

%>


<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Insert title here</title>
</head>
<body>



<%
	Class.forName("com.mysql.jdbc.Driver");

try 
{
	Connection conn = DriverManager.getConnection("jdbc:mysql://localhost/cse135?user=test&password=test");
    conn.setAutoCommit(false);
    
    ResultSet rs = conn.createStatement().executeQuery("SELECT USERS.sta, CATEGORY.nam, PRODUCTS.price " + 
   		 "FROM PURCHASES " +
   		 "INNER JOIN PRODUCTS ON PRODUCTS.id = PURCHASES.product " +
   		 "INNER JOIN CATEGORY ON PRODUCTS.cat = CATEGORY.id " + 
   		 "INNER JOIN USERS ON USERS.id = PURCHASES.customer " + 
   		 "ORDER BY USERS.sta, CATEGORY.nam;");
    
    
    StaOrganizer o = new StaOrganizer();
    while(rs.next())
   	  o.add(rs.getString(1), rs.getString(2), rs.getInt(3));
    
   
    String[] cats = o.getCatList();
    String[] states = o.getStateList();
    
    String dump = "<table border=\"1\">\n<tr><th> </th>\n";
    for(String s : cats)
   	  dump += "<th>" + s + "</th>\n";
   	dump += "</tr>\n";
   	
   	for(String state : states)
   	{
   		dump += "<tr>\n<td>" + state + "</td>\n";
   		for(String cat : cats)
   		   dump += "<td>" + o.fetchPrice(state, cat) + "</td>\n";
   	
   		dump += "</tr>\n";
   	}
   	dump +="</table>";
   	out.println(dump);
   	
}
catch(Throwable e)
{
	e.printStackTrace();
}
%>



</body>
</html>