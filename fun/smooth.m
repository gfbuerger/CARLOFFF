## usage: y = smooth (x, d=0.5, filtopt="mean")
##
## smooth x with degree between 0 and 1
function y = smooth (x, d=0.5, filtopt="mean")

   global FILTOPT
   FILTOPT = filtopt ;
   
   pkg load signal
   
   N = size(x) ;
   
   [b a] = butter(3, 1-d) ;

   x = reshape(x, N(1), prod(N(2:end))) ;

   [~, s] = polyfit((1:N(1))', x, 1) ;
   x = x - s.yf ;

   y = arrayfun(@(j) filt(b, a, x(:,j)), 1:columns(x), "UniformOutput", false) ;
   y = cell2mat(y) ;

   y = y + s.yf ;
   
   y = reshape(y, N) ;

endfunction


function y = filt(b,a,x)
%GFILT Zero-phase forward and reverse digital filtering.
%   Y = FILT(B, A, X) filters the data in vector X with the filter described
%   by vectors A and B to create the filtered data Y.  The filter is described 
%   by the difference equation:
%
%     y(n) = b(1)*x(n) + b(2)*x(n-1) + ... + b(nb+1)*x(n-nb)
%                      - a(2)*y(n-1) - ... - a(na+1)*y(n-na)
%
%
%   After filtering in the forward direction, the filtered sequence is then 
%   reversed and run back through the filter; Y is the time reverse of the 
%   output of the second filtering operation.  The result has precisely zero 
%   phase distortion and magnitude modified by the square of the filter's 
%   magnitude response.  Care is taken to minimize startup and ending 
%   transients by matching initial conditions.
%
%   The length of the input x must be more than three times
%   the filter order, defined as max(length(b)-1,length(a)-1).
%
%   Note that FILT should not be used with differentiator and Hilbert FIR
%   filters, since the operation of these filters depends heavily on their
%   phase response.
%
%   See also FILTER.

%   References: 
%     [1] Sanjit K. Mitra, Digital Signal Processing, 2nd ed., McGraw-Hill, 2001
%     [2] Fredrik Gustafsson, Determining the initial states in forward-backward 
%         filtering, IEEE Transactions on Signal Processing, pp. 988--992, April 1996, 
%         Volume 44, Issue 4

%   Author(s): L. Shure, 5-17-88
%   revised by T. Krauss, 1-21-94
%   Initial Conditions: Fredrik Gustafsson
%   Copyright 1988-2002 The MathWorks, Inc.
%   $Revision: 1.7 $  $Date: 2002/04/15 01:11:19 $

    global FILTOPT

    error(nargchk(3,3,nargin))
    if (isempty(b) || isempty(a) || isempty(x))
        y = [];
        return
    endif

    [m,n] = size(x);
    if (n>1) && (m>1)
        y = x;
        for i=1:n  % loop over columns
	   if !all(isnan(x(:,i)))
              y(:,i) = filt(b,a,x(:,i));
	   else
	      y(:,i) = repmat(NaN, m, 1) ;
	   endif
        endfor
        return
        % error('Only works for vector input.')
    endif
    if m==1
        x = x(:);   % convert row to column
    endif
    I = ~isnan(x) ;
    u = x(I) ;
    len = size(u,1);   % length of input
    b = b(:).';
    a = a(:).';
    nb = length(b);
    na = length(a);
    nfilt = max(nb,na);

    nfact = 3*(nfilt-1);  % length of edge transients

    if (len<=nfact),    % input data too short!
        error('Data must have length more than 3 times filter order.');
    endif

% set up filter's initial conditions to remove dc offset problems at the 
% beginning and end of the sequence
    if nb < nfilt, b(nfilt)=0; endif   % zero-pad if necessary
    if na < nfilt, a(nfilt)=0; endif
% use sparse matrix to solve system of linear equations for initial conditions
% zi are the steady-state states of the filter b(z)/a(z) in the state-space 
% implementation of the 'filter' command.
    rows = [1:nfilt-1  2:nfilt-1  1:nfilt-2];
    cols = [ones(1,nfilt-1) 2:nfilt-1  2:nfilt-1];
    data = [1+a(2) a(3:nfilt) ones(1,nfilt-2)  -ones(1,nfilt-2)];
    sp = sparse(rows,cols,data);
    zi = sp \ ( b(2:nfilt).' - a(2:nfilt).'*b(1) );
% non-sparse:
% zi = ( eye(nfilt-1) - [-a(2:nfilt).' [eye(nfilt-2); zeros(1,nfilt-2)]] ) \ ...
%      ( b(2:nfilt).' - a(2:nfilt).'*b(1) );

% Extrapolate beginning and end of data sequence using a "reflection
% method".  Slopes of original and extrapolated sequences match at
% the end points.
% This reduces end effects.
    switch FILTOPT
       case 0
	  y = [zeros(nfact,1); u; zeros(nfact,1)] ;
       case "mean"
	  y = [repmat(mean(u(1:nfact)),nfact,1); u; repmat(mean(u(end-nfact+1:end)),nfact,1)] ;
       case "reflect"
	  y = [2*u(1)-u((nfact+1):-1:2);u;2*u(len)-u((len-1):-1:len-nfact)];
       otherwise
	  y = u ;
    endswitch
% filter, reverse data, filter again, and reverse data again

    y = filter(b,a,y,[zi*y(1)]);

    if ~isempty(FILTOPT)
       y = y(length(y):-1:1);
       y = filter(b,a,y,[zi*y(1)]);
       y = y(length(y):-1:1);

% remove extrapolated pieces of y
       y([1:nfact len+nfact+(1:nfact)]) = [];
    endif
    
## insert NaNs
    w = y ;
    y = x ;
    y(I) = w ;

    if m == 1
        y = y.';   % convert back to row if necessary
    endif

endfunction
