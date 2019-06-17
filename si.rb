require 'decisiontree'


attributes = ['@kitchen', 'queue[menu]', 'queue[food]', 'queue[order]', 'queue[receipt]', 'queue[ready_to_pay]', 'queue[clean]']
training = [
  #@kitch, menu, food, order, receipt, rtp, clean, result
  ["true", "false", "false", "false", "false", "false", "false", 'menu'],
  ["false", "false", "false", "false", "false", "false", "false", 'menu'],
  ["false", "false", "true", "false", "false", "false", "false", 'menu'],
  ["true", "false", "true", "true", "true", "true", "true", 'menu'],
  ["false", 'false', 'true', 'false', 'true', 'true', 'true', 'menu'],
  #["false", "false", "false", "true", "true", "false", "false", 'menu'],
  
  ["false", "true", "false", "false", "false", "false", "false", 'order'],
  ["true", "true", "true", "false", "false", "false", "false", "order"],
  ["false", "true", "true", "false", "true", "true", "true", "order"],
  ["true", "true", "true", "false", "true", "true", "true", "order"],
  ["false", "true", "true", "false", "false", "true", "true", "order"],
  #["false", "true", "true", "false", "false", "true", "true", "order"],
  #["false", "true", "true", "false", "false", "false", "false", "order"],

  ["false", "true", "false", "false", "false", "false", "false", "food"],
  ["true", "true", "false", "false", "false", "false", "false", "food"],
  #["true", "false", "false", "true", "true", "true", "true", "food"],
  ["true", "true", "false", "true", "true", "true", "true", "food"],
  ["false", "true", "false", "true", "true", "true", "true", "food"],
  #["true", "false", "false", "false", "true", "false", "true", "food"],
  #["true", "false", "false", "true", "false", "false", "true", "food"],
    
  ["false", "true", "true", "true", "false", "false", "false", 'receipt'],
  ["true", "true", "true", "true", "false", "false", "false", "receipt"],
  ["false", "true", "true", "true", "false", "true", "true", "receipt"],
  ["true", "true", "true", "true", "false", "true", "true", "receipt"],

  ["false", "true", "true", "true", "true", "false", "false", 'rtp'],
  ["true", "true", "true", "true", "true", "false", "false", "rtp"],
  ["false", "true", "true", "true", "true", "false", "true", "rtp"],
  ["true", "true", "true", "true", "true", "false", "true", "rtp"],

  ["false", "true", "true", "true", "true", "true", "false", 'clean'],
  ["true", "true", "true", "true", "true", "true", "false", "clean"],

  ["false", "true", "true", "true", "true", "true", "true", 'return'],
  ["true", "true", "true", "true", "true", "true", "true", "return"]

]
dec_tree = DecisionTree::ID3Tree.new(attributes, training, 1, :discrete)
dec_tree.train
dec_tree.train
dec_tree.graph('tak')