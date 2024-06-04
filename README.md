### TSQL XML Beautifier made for special environment. Maybe it'll help someone.

Changing something like this:
```xml
<?xml version="1.0" encoding="UTF-8"?><root><element_base><element_sub><![CDATA[1]]></element_sub><element_sub2>Hello World!</element_sub2></element_base></root>
```
into this:
```xml
<?xml version="1.0" encoding="UTF-8"?>
<root>
    <element_base>
        <element_sub><![CDATA[1]]></element_sub>
        <element_sub2>Hello World!</element_sub2>
    </element_base>
</root>
```
