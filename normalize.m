function [y] = normalize(x,type)
if type == 1
    y = x/max(x(:));
elseif type ==2
    y = (x - min(x(:)))/(max(x(:))-min(x(:)));
else
    y = x;
end

