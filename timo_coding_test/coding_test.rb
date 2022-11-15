# #!/usr/bin/env ruby
# # Assume you have three distributed data sources. Your task
# # is to collect all data from there and return an aggregated result.
#
# slips = {
#   "slip_23" => {
#     transactions: [123, 456],
#     shop: 1
#   },
#   "slip_42" => {
#     transactions: [789],
#     shop: 2
#   }
# }
#
# transactions = [
#   {
#     id: 123,
#     amount: 10.01,
#     payout: false
#   },
#   {
#     id: 456,
#     amount: 5.01,
#     payout: true
#   },
#   {
#     id: 789,
#     amount: 20.10,
#     payout: false
#   }
# ]
#
# shops = [
#   [1, 'Zalando.de'],
#   [2, 'Amazon.com']
# ]
#
# #### {1=>"Zalando.de", 2=>"Amazon.com"}
#
# # Task: Use the three data sources above and create the following result:
# result = {
#   23 => {
#     number_transactions: 2, # Number of transactions per slip
#     total_amount: 5,        # Total amount of transactions (a payout must
#                             # be subtracted instead of added!)
#     shop: 'Zalando.de'      # Shop title
#   },
#   42 => {
#     number_transactions: 1,
#     total_amount: 20.10,
#     shop: 'Amazon.com'
#   }
# }
#
# puts result
#
#
# P
# -given 1 hash and 2 arrays, return a new hash that processes information from the 3
# data sources
# E
#
# D
# -input 1 hash, 2 arrays
# -output 1 hash
# A
# -create a method that accepts 3 arguments
# -create empty result_hsh to store processed data
# -turn argument shop_arr to hash, shop_arr.to_h, name it shops_hash
# -create local variable `new_slip`, set it to slips first key/value pair (slips.first)
# -create variable `slip_name` = new_slip[0], gsub "slip_" out of name and leave only the number
# -create variable `transactions` = new_slip[1].size
# -create variable `shop_name` =  shops_hash[new_slip[2][:shop]]
# -create method find_total_amount, with arguments transactions array, ids_arr, iterate through it and
#   a) create `sums_arr` as empty array
#   b) iterate through transactions, for each element,  iterate through transactions  grab the values for amount and append it to `sum_arr`, but look at the payout field,
# if its true, then the amount must have -1 multiplied to it first
#   c) return `sums_arr`.sum
# -create variable `total_amount`, set it to return value of find_total_amount
# -in result_hsh, add all local variables above to it
# -delete slips first entry using the key
# -repeat the process with next k/v in slips
require 'byebug'

def find_total_amount(transactions, ids)
  sums_arr = []

  ids.each do |check_id|
    transactions.each do |transaction|
      if transaction[:id] == check_id
        if transaction[:payout] == true
          sums_arr << transaction[:amount] * -1
        else
          sums_arr << transaction[:amount]
        end
      end
    end
  end

  sums_arr.sum
end


def process_slip(slip_hsh, transaction_arr, shop_arr)
  result_hsh = {}
  shop_hsh = shop_arr.to_h
  slips = slip_hsh.clone

  loop do
    new_slip = slips.first
    slip_name = new_slip[0].gsub('slip_', '')
    transactions = new_slip[1][:transactions].size
    shop_name = shop_hsh[new_slip[1][:shop]]
    total_amount = find_total_amount(transaction_arr, new_slip[1][:transactions])

    result_hsh[slip_name] = {
                              number_transactions: transactions,
                              total_amount: total_amount,
                              shop: shop_name
                          }
    slips.delete(new_slip[0])
    break if slips.empty?
  end
  result_hsh

end

slips = {
  "slip_23" => {
    transactions: [123, 456],
    shop: 1
  },
  "slip_42" => {
    transactions: [789],
    shop: 2
  }
}

transactions = [
  {
    id: 123,
    amount: 10.01,
    payout: false
  },
  {
    id: 456,
    amount: 5.01,
    payout: true
  },
  {
    id: 789,
    amount: 20.10,
    payout: false
  }
]

shops = [
  [1, 'Zalando.de'],
  [2, 'Amazon.com']
]

puts process_slip(slips, transactions, shops)
