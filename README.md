# Converter from yaml to csv

## Run script
- Add permission to script:
    ```
    chmod u+x script.sh
    ```

- Run script:
    ```
    ./script.sh
        Enter name of yaml file
    or 
    ./script.sh FILE_NAME
    ```

## Expected input
```
-
  id: 1
  name: Johnson, Smith, and Jones Co.
  amount: 345.33
  Remark: Pays on time

-
  id: 2
  name: Sam "Mad Dog" Smith
  amount: 993.44
  Remark:

-
  id: 3
  name: Barney & Company
  amount: 0
  Remark: "Great to work with\nand always pays with cash."

-
  id: 4
  name: 'Johnson''s Automotive'
  amount: 2344
  Remark: 
```

## Expected output
```
id,name,amount,Remark
1,"Johnson, Smith, and Jones Co.",345.33,Pays on time
2,Sam "Mad Dog" Smith,993.44,
3,Barney & Company,0,"Great to work with\nand always pays with cash."
4,'Johnson''s Automotive',2344,
```
