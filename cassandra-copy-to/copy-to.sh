
#table product_15738 from 10.33.245.222 to 177.153.231.114
set -x
cqlsh-astra/bin/cqlsh --connect-timeout=15 10.33.245.222 -e "describe btg360.product_15738;" > /storage/tmp/schema-product_15738.cql
cqlsh-astra/bin/cqlsh --connect-timeout=15 177.153.231.114 < /storage/tmp/schema-product_15738.cql && rm -f /storage/tmp/schema-product_15738.cql
cqlsh-astra/bin/cqlsh --connect-timeout=15 10.33.245.222 -e "COPY btg360.product_15738 TO   '/storage/tmp/product_15738-1670431039.csv';" > /dev/null
du -sh '/storage/tmp/product_15738-1670431039.csv' '/storage/tmp/schema-product_15738.cql'
cqlsh-astra/bin/cqlsh --connect-timeout=15 177.153.231.114 -e "COPY btg360.product_15738 FROM '/storage/tmp/product_15738-1670431039.csv';" > /dev/null && rm -f /storage/tmp/product_15738-1670431039.csv
du -sh '/storage/tmp/*.csv' /storage/tmp/*.cql

#table cookie_email_optin_11255 from 10.33.245.222 to 177.153.231.114
set -x
cqlsh-astra/bin/cqlsh --connect-timeout=15 10.33.245.222 -e "describe btg360.cookie_email_optin_11255;" > /storage/tmp/schema-cookie_email_optin_11255.cql
cqlsh-astra/bin/cqlsh --connect-timeout=15 177.153.231.114 < /storage/tmp/schema-cookie_email_optin_11255.cql && rm -f /storage/tmp/schema-cookie_email_optin_11255.cql
cqlsh-astra/bin/cqlsh --connect-timeout=15 10.33.245.222 -e "COPY btg360.cookie_email_optin_11255 TO   '/storage/tmp/cookie_email_optin_11255-1670431039.csv';" > /dev/null
du -sh '/storage/tmp/cookie_email_optin_11255-1670431039.csv' '/storage/tmp/schema-cookie_email_optin_11255.cql'
cqlsh-astra/bin/cqlsh --connect-timeout=15 177.153.231.114 -e "COPY btg360.cookie_email_optin_11255 FROM '/storage/tmp/cookie_email_optin_11255-1670431039.csv';" > /dev/null && rm -f /storage/tmp/cookie_email_optin_11255-1670431039.csv
du -sh '/storage/tmp/*.csv' /storage/tmp/*.cql

#table cart_11255 from 10.33.245.222 to 177.153.231.114
set -x
cqlsh-astra/bin/cqlsh --connect-timeout=15 10.33.245.222 -e "describe btg360.cart_11255;" > /storage/tmp/schema-cart_11255.cql
cqlsh-astra/bin/cqlsh --connect-timeout=15 177.153.231.114 < /storage/tmp/schema-cart_11255.cql && rm -f /storage/tmp/schema-cart_11255.cql
cqlsh-astra/bin/cqlsh --connect-timeout=15 10.33.245.222 -e "COPY btg360.cart_11255 TO   '/storage/tmp/cart_11255-1670431039.csv';" > /dev/null
du -sh '/storage/tmp/cart_11255-1670431039.csv' '/storage/tmp/schema-cart_11255.cql'
cqlsh-astra/bin/cqlsh --connect-timeout=15 177.153.231.114 -e "COPY btg360.cart_11255 FROM '/storage/tmp/cart_11255-1670431039.csv';" > /dev/null && rm -f /storage/tmp/cart_11255-1670431039.csv
du -sh '/storage/tmp/*.csv' /storage/tmp/*.cql

#table navigated_product_purchased_11255 from 10.33.245.222 to 177.153.231.114
set -x
cqlsh-astra/bin/cqlsh --connect-timeout=15 10.33.245.222 -e "describe btg360.navigated_product_purchased_11255;" > /storage/tmp/schema-navigated_product_purchased_11255.cql
cqlsh-astra/bin/cqlsh --connect-timeout=15 177.153.231.114 < /storage/tmp/schema-navigated_product_purchased_11255.cql && rm -f /storage/tmp/schema-navigated_product_purchased_11255.cql
cqlsh-astra/bin/cqlsh --connect-timeout=15 10.33.245.222 -e "COPY btg360.navigated_product_purchased_11255 TO   '/storage/tmp/navigated_product_purchased_11255-1670431039.csv';" > /dev/null
du -sh '/storage/tmp/navigated_product_purchased_11255-1670431039.csv' '/storage/tmp/schema-navigated_product_purchased_11255.cql'
cqlsh-astra/bin/cqlsh --connect-timeout=15 177.153.231.114 -e "COPY btg360.navigated_product_purchased_11255 FROM '/storage/tmp/navigated_product_purchased_11255-1670431039.csv';" > /dev/null && rm -f /storage/tmp/navigated_product_purchased_11255-1670431039.csv
du -sh '/storage/tmp/*.csv' /storage/tmp/*.cql

#table navigation_11255 from 10.33.245.222 to 177.153.231.114
set -x
cqlsh-astra/bin/cqlsh --connect-timeout=15 10.33.245.222 -e "describe btg360.navigation_11255;" > /storage/tmp/schema-navigation_11255.cql
cqlsh-astra/bin/cqlsh --connect-timeout=15 177.153.231.114 < /storage/tmp/schema-navigation_11255.cql && rm -f /storage/tmp/schema-navigation_11255.cql
cqlsh-astra/bin/cqlsh --connect-timeout=15 10.33.245.222 -e "COPY btg360.navigation_11255 TO   '/storage/tmp/navigation_11255-1670431039.csv';" > /dev/null
du -sh '/storage/tmp/navigation_11255-1670431039.csv' '/storage/tmp/schema-navigation_11255.cql'
cqlsh-astra/bin/cqlsh --connect-timeout=15 177.153.231.114 -e "COPY btg360.navigation_11255 FROM '/storage/tmp/navigation_11255-1670431039.csv';" > /dev/null && rm -f /storage/tmp/navigation_11255-1670431039.csv
du -sh '/storage/tmp/*.csv' /storage/tmp/*.cql

#table order_11255 from 10.33.245.222 to 177.153.231.114
set -x
cqlsh-astra/bin/cqlsh --connect-timeout=15 10.33.245.222 -e "describe btg360.order_11255;" > /storage/tmp/schema-order_11255.cql
cqlsh-astra/bin/cqlsh --connect-timeout=15 177.153.231.114 < /storage/tmp/schema-order_11255.cql && rm -f /storage/tmp/schema-order_11255.cql
cqlsh-astra/bin/cqlsh --connect-timeout=15 10.33.245.222 -e "COPY btg360.order_11255 TO   '/storage/tmp/order_11255-1670431039.csv';" > /dev/null
du -sh '/storage/tmp/order_11255-1670431039.csv' '/storage/tmp/schema-order_11255.cql'
cqlsh-astra/bin/cqlsh --connect-timeout=15 177.153.231.114 -e "COPY btg360.order_11255 FROM '/storage/tmp/order_11255-1670431039.csv';" > /dev/null && rm -f /storage/tmp/order_11255-1670431039.csv
du -sh '/storage/tmp/*.csv' /storage/tmp/*.cql

#table product_more_navigated_11255 from 10.33.245.222 to 177.153.231.114
set -x
cqlsh-astra/bin/cqlsh --connect-timeout=15 10.33.245.222 -e "describe btg360.product_more_navigated_11255;" > /storage/tmp/schema-product_more_navigated_11255.cql
cqlsh-astra/bin/cqlsh --connect-timeout=15 177.153.231.114 < /storage/tmp/schema-product_more_navigated_11255.cql && rm -f /storage/tmp/schema-product_more_navigated_11255.cql
cqlsh-astra/bin/cqlsh --connect-timeout=15 10.33.245.222 -e "COPY btg360.product_more_navigated_11255 TO   '/storage/tmp/product_more_navigated_11255-1670431039.csv';" > /dev/null
du -sh '/storage/tmp/product_more_navigated_11255-1670431039.csv' '/storage/tmp/schema-product_more_navigated_11255.cql'
cqlsh-astra/bin/cqlsh --connect-timeout=15 177.153.231.114 -e "COPY btg360.product_more_navigated_11255 FROM '/storage/tmp/product_more_navigated_11255-1670431039.csv';" > /dev/null && rm -f /storage/tmp/product_more_navigated_11255-1670431039.csv
du -sh '/storage/tmp/*.csv' /storage/tmp/*.cql

#table product_more_purchased_11255 from 10.33.245.222 to 177.153.231.114
set -x
cqlsh-astra/bin/cqlsh --connect-timeout=15 10.33.245.222 -e "describe btg360.product_more_purchased_11255;" > /storage/tmp/schema-product_more_purchased_11255.cql
cqlsh-astra/bin/cqlsh --connect-timeout=15 177.153.231.114 < /storage/tmp/schema-product_more_purchased_11255.cql && rm -f /storage/tmp/schema-product_more_purchased_11255.cql
cqlsh-astra/bin/cqlsh --connect-timeout=15 10.33.245.222 -e "COPY btg360.product_more_purchased_11255 TO   '/storage/tmp/product_more_purchased_11255-1670431039.csv';" > /dev/null
du -sh '/storage/tmp/product_more_purchased_11255-1670431039.csv' '/storage/tmp/schema-product_more_purchased_11255.cql'
cqlsh-astra/bin/cqlsh --connect-timeout=15 177.153.231.114 -e "COPY btg360.product_more_purchased_11255 FROM '/storage/tmp/product_more_purchased_11255-1670431039.csv';" > /dev/null && rm -f /storage/tmp/product_more_purchased_11255-1670431039.csv
du -sh '/storage/tmp/*.csv' /storage/tmp/*.cql

#table product_similar_11255 from 10.33.245.222 to 177.153.231.114
set -x
cqlsh-astra/bin/cqlsh  --request-timeout=120 --connect-timeout=15 10.33.245.222 -e "describe btg360.product_similar_11255;" > /storage/tmp/schema-product_similar_11255.cql
cqlsh-astra/bin/cqlsh  --request-timeout=120 --connect-timeout=15 177.153.231.114 < /storage/tmp/schema-product_similar_11255.cql && rm -f /storage/tmp/schema-product_similar_11255.cql
cqlsh-astra/bin/cqlsh  --request-timeout=120 --connect-timeout=15 10.33.245.222 -e "COPY btg360.product_similar_11255 TO   '/storage/tmp/product_similar_11255-1670431039.csv';" > /dev/null
du -sh '/storage/tmp/product_similar_11255-1670431039.csv' '/storage/tmp/schema-product_similar_11255.cql'
cqlsh-astra/bin/cqlsh  --request-timeout=120 --connect-timeout=15 177.153.231.114 -e "COPY btg360.product_similar_11255 FROM '/storage/tmp/product_similar_11255-1670431039.csv';" > /dev/null && rm -f /storage/tmp/product_similar_11255-1670431039.csv
du -sh '/storage/tmp/*.csv' /storage/tmp/*.cql

#table products_navigated_together_11255 from 10.33.245.222 to 177.153.231.114
set -x
cqlsh-astra/bin/cqlsh --connect-timeout=15 10.33.245.222 -e "describe btg360.products_navigated_together_11255;" > /storage/tmp/schema-products_navigated_together_11255.cql
cqlsh-astra/bin/cqlsh --connect-timeout=15 177.153.231.114 < /storage/tmp/schema-products_navigated_together_11255.cql && rm -f /storage/tmp/schema-products_navigated_together_11255.cql
cqlsh-astra/bin/cqlsh --connect-timeout=15 10.33.245.222 -e "COPY btg360.products_navigated_together_11255 TO   '/storage/tmp/products_navigated_together_11255-1670431039.csv';" > /dev/null
du -sh '/storage/tmp/products_navigated_together_11255-1670431039.csv' '/storage/tmp/schema-products_navigated_together_11255.cql'
cqlsh-astra/bin/cqlsh --connect-timeout=15 177.153.231.114 -e "COPY btg360.products_navigated_together_11255 FROM '/storage/tmp/products_navigated_together_11255-1670431039.csv';" > /dev/null && rm -f /storage/tmp/products_navigated_together_11255-1670431039.csv
du -sh '/storage/tmp/*.csv' /storage/tmp/*.cql

#table products_purchased_together_11255 from 10.33.245.222 to 177.153.231.114
set -x
cqlsh-astra/bin/cqlsh --connect-timeout=15 10.33.245.222 -e "describe btg360.products_purchased_together_11255;" > /storage/tmp/schema-products_purchased_together_11255.cql
cqlsh-astra/bin/cqlsh --connect-timeout=15 177.153.231.114 < /storage/tmp/schema-products_purchased_together_11255.cql && rm -f /storage/tmp/schema-products_purchased_together_11255.cql
cqlsh-astra/bin/cqlsh --connect-timeout=15 10.33.245.222 -e "COPY btg360.products_purchased_together_11255 TO   '/storage/tmp/products_purchased_together_11255-1670431039.csv';" > /dev/null
du -sh '/storage/tmp/products_purchased_together_11255-1670431039.csv' '/storage/tmp/schema-products_purchased_together_11255.cql'
cqlsh-astra/bin/cqlsh --connect-timeout=15 177.153.231.114 -e "COPY btg360.products_purchased_together_11255 FROM '/storage/tmp/products_purchased_together_11255-1670431039.csv';" > /dev/null && rm -f /storage/tmp/products_purchased_together_11255-1670431039.csv
du -sh '/storage/tmp/*.csv' /storage/tmp/*.cql
