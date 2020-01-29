classdef utils
    %UTILS Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        
    end
    
    methods
        function obj = utils()
            
        end
    end
    
    methods(Static)
        function [mi] = t_norma(a, b)
            % produto
            mi = a.*b;
        end
         
        function [mi] = s_norma(varargin)
            if nargin==1
                a=varargin{1};
                % max
                mi = max(a);
            elseif nargin==2
                a=varargin{1};
                b=varargin{2};
                % max
                mi = max(a,b);              
            else
              error('s_norma accepts up to 2 input arguments!')
            end
        end

    end
end

