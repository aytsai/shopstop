Shopstop (Final) with MySQL, Ajax/JS, and JSPs - UCSD CSE 2013  
- Patrick Wilson  
- Alec Wu  
- Ariana Tsai  
  
(Ariana's forked version for reference purposes. Github version and final version differed.)  
  
Part 1 (earned 100/100): Created the initial functionality of the site so that a user can sign up, sign in, log out, buy products, and insert/modify/delete products and categories. Done in JSPs with connection to a local MySQL database. Users are separated into customers and owners, and they can only view certain pages depending on their permissions.  
  
Part 2 (earned 90/100): Created an analytics table with filtering (ie: seasons, categories, product names) so that an owner can view product sales information. Points were taken off for slow initial loadup of the table. Still, on subsequent loadups of the table, the app ran quickly with 10000 customers, 10000 products, and 1000000 purchases.  
  
Part 3 (earned 100/100): Implemented Ajax/JS so that UI was enhanced and created a live sales table that would update itself automatically every two seconds without having to rebuild itself from the database.