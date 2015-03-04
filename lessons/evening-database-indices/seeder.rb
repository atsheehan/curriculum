require "pg"

UNITS = ["tbspn(s)", "tspn(s)", "gallon(s)", "lb(s)", "kg", "g", "cup(s)"]
NAMES = ["Alfalfa sprouts", "Artichoke hearts", "Arugula", "Avocado", "Beans","Broccoli florets","Cabbage","Cauliflower florets","Celery","Chicory greens","Chinese cabbage","Chives","Cucumber","Daikon radish","Endive","Escarole","Fennel","Greens","Iceberg lettuce","Jicama","Loose-leaf lettuce","Mesclun", "Mung bean sprouts", "Black Olives", "Onion", "Green bell peppers", "Red bell peppers","Radicchio","Radishes","Romaine lettuce","Scallion/green onion","Spinach","Tomato","Watercress","Artichoke","Asparagus","Beans","Beet greens","Bok choy","Broccoflower","Broccoli","Broccoli rabe","Brussels sprouts","Cabbage","Cardoon","Cauliflower","Celery","Swiss Chard","Chayote","Collard greens","Dandelion greens","Eggplant","Escarole","Fennel","Hearts of palm","Kale","Kohlrabi","Leeks","Mustard greens","Cactus pods","Okra","Onion","Pumpkin","Sauerkraut","Scallions","Shallots","Sorrel","Spaghetti squash","Spinach","Summer squash","Tomatillo","Tomato","Water chestnuts","Zucchini","Quorn burger","Quorn roast","Quorn unbreaded cutlet","Seitan","Shirataki soy noodles","Tempeh","Tofu","Blue cheese","Brie","Cheddar or Colby","Cream cheese","Feta","Gouda","Parmesan","Swiss","Skim Milk","Quark","Sour cream","Yogurt","Mayonnaise","Canola Oil","Coconut Oil","Safflower Oil","Flaxseed Oil","Olive Oil","Sesame Seed Oil","Grapeseed Oil","Walnut Oil","Butter","Beer","Bourbon","Champagne","Gin","Rum","Scotch","Sherry","Vodka","Wine","Blackberries","Blueberries","Boysenberries","Cherries","Cranberries","Currants","Gooseberries","Raspberries","Almonds","Almond butter","Almond meal/flour","Brazil nuts","Cashews","Cashew butter","Macadamias","Macadamia butter","Hazelnuts","Peanuts","Peanut butter","Pecans","Pine nuts", "Pistachios", "Pumpkin seeds","Sesame seeds","Sunflower seed butter","Tahini","Walnuts","Blue cheese dressing","Caesar salad dressing","Italian dressing","Lemon juice","Lime juice","Oil and vinegar","Ranch dressing"]

conn = PG.connect(dbname: "ingredients")

starting = Time.now

count = 0
1_000.times do
  sql = "INSERT INTO ingredients (quantity, unit, name) VALUES "
  10_000.times do
    quantity = rand(1..10)
    unit = UNITS.sample
    name = NAMES.sample

    sql += "('#{quantity}', '#{unit}', '#{name}'),"
  end

  sql = sql.chop

  conn.exec(sql)
  total = 10_000*(count + 1)
  total = total.to_s
  puts "added batch #{count + 1} of 10,000 records for a total of #{total.gsub(/(\d)(?=(\d\d\d)+(?!\d))/, "\\1#{','}")} records."
  puts "Total time elapsed: #{(Time.now - starting).to_i} seconds."
  count += 1
end

conn.close
