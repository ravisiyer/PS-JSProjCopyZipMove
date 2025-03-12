write-host "There are a total of $($args.count) parameters"
for ( $i = 0; $i -lt $args.count; $i++ ) {
    write-host "Parameter  $i is $($args[$i])"
} 