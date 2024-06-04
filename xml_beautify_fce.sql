CREATE FUNCTION xml_beautify_fce(
    @t varchar(max)/*BY*/
)
RETURNS varchar(max)/*BY*/
AS
BEGIN
    DECLARE @rtrn varchar(max)/*BY*/, @indx int/*BY*/, @nl varchar(2)/*BY*/ = char(13)/*BY*/ + char(10)/*BY*/,
        @node varchar(max)/*BY*/, @node_before varchar(max)/*BY*/, @level int/*BY*/,
        @indent varchar(4)/*BY*/, @nl_an tinyint/*BY*/, @indent_an tinyint/*BY*/
    SELECT @level = 0, @indent = Replicate(' ', 4)
    
    SELECT @t = Replace(Replace(@t, char(10), ''), char(13), '')
    
    WHILE @indx <> 0 BEGIN
        SELECT @nl_an = 1, @indent_an = 1
        SELECT @indx = Charindex('<', Right(@t, Len(@t) -1))
        IF @indx <> 0 BEGIN
            SELECT @node = Left(@t, @indx)
            SELECT @level = @level + CASE
                WHEN Substring(@node_before, 2, 1) = '?' THEN 0
                WHEN Substring(@node, 2, 1) NOT in ('!', '/') AND Substring(@node_before, 2, 1) <> '/' THEN 1
                WHEN Substring(@node, 2, 1) = '/' AND Substring(@node_before, 2, 1) = '/' THEN -1
                ELSE 0 END
            SELECT @nl_an = CASE
                WHEN Coalesce(@node_before, '') = '' THEN 0
                WHEN Substring(@node, 2, 1) NOT in ('!', '/') THEN 1
                WHEN Substring(@node, 2, 1) = '/' AND Substring(@node_before, 2, 1) = '/' THEN 1
                ELSE 0 END
            SELECT @indent_an = CASE
                WHEN Substring(@node_before, 2, 1) = '?' THEN 0
                WHEN Substring(@node, 2, 1) = '!' THEN 0
                WHEN Substring(@node, 2, 1) = '/' AND (Substring(@node_before, 2, 1) = '!' or Substring(@node_before, 2, 1) NOT in ('!', '/')) THEN 0
                ELSE 1 END
            SELECT @rtrn = @rtrn + CASE WHEN @nl_an = 1 THEN @nl ELSE '' END + CASE WHEN @indent_an = 1 THEN Replicate(@indent, @level) ELSE '' END + Ltrim(Rtrim(@node))
            SELECT @t = stuff(@t, 1, @indx, '')
        END ELSE BEGIN
            SELECT @rtrn = @rtrn + @nl + @t
        END
        SELECT @node_before = @node
    END
    
    RETURN Coalesce(@rtrn, '')
END
