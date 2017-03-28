#!/usr/bin/python3
import sys, os
import random
from pprint import pprint
import requests
import simplejson as json
import asyncio
import websockets
import time
from pistonbase import operations
from collections import OrderedDict
from piston.transactionbuilder import TransactionBuilder
from graphenebase import base58
from piston import Steem

import config

st = Steem ( keys = [ config.wif ], node = config.node )

old_price = "999999.999"

while True:
  print ( "[" + str ( time.time() ) + "] Checking coinmarketcap..." )

  r_cmc = requests.get ( "https://api.coinmarketcap.com/v1/ticker/" )

  result_cmc = json.loads ( r_cmc.text ) 

  for i in result_cmc:
    if ( i [ 'id' ] == 'steem' ):
      price_usd = i [ 'price_usd' ]
      formatted_price = "{0:.3f}".format ( float ( i [ 'price_usd' ] ) )
      if ( formatted_price != old_price ):
        print ( "Setting price feed to: " + formatted_price )
        tx = TransactionBuilder ()
        tx.appendOps (
          operations.Feed_publish (
            **{ "publisher": config.owner,
                "exchange_rate": {
                  "base": formatted_price + " SBD",
                  "quote": config.quote + " STEEM"
                  }
              }
            )
          )
        tx.appendSigner ( config.owner, "active" )
        tx.sign()
        try:
          tx.broadcast ()
          print ( "Successfully set feed to:" )
          print ( "base = " + formatted_price )
          print ( "quote = " + config.quote + " STEEM" )
        except:
          print ( "Transaction broadcast failed" )
        old_price = formatted_price
  print ("Pausing for around 1 hour")
  time.sleep ( int ( random.random() * 7200 ) )
