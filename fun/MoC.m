## usage: res = MoC (skl, o, f)
##
## return binary skill 'skl' of the MoC
function res = MoC (skl, o, f)

   [rf, cf] = size (f);
   [ro, co] = size (o);
   if (co == 1 & cf > 1)
      o = repmat (o, 1, cf);
   endif
   I = isfinite (f) & isfinite (o);
   n = sum (I);
   a = sum (I & f > 0 & o > 0) ./ n;
   s = sum (I & o > 0) ./ n;
   r = sum (I & f > 0) ./ n;

   a = sum (I & f > 0 & o > 0) ./ n;
   b = sum (I & f > 0 & o <= 0) ./ n;
   c = sum (I & f <= 0 & o > 0) ./ n;
   d = sum (I & f <= 0 & o <= 0) ./ n;

##   H = a / s ;
##   F = (r - a) / r ;

   switch skl
      case "EDS"
	 z = 2*log(s) ;
	 n = log(a) ;
	 res = z./n -1 ;
      case "PHI"
	 z = a - s.*r ;
	 n = sqrt(s.*(1-s).*r.*(1-r));
	 if (n == 0)
	    res = NaN ;
	 else
	    res = z./n;
	 endif
##      case "PHI0"
##	 z = (H-F).*(B-H) ;
##	 n = sqrt(B.*(B-H+(1-B).*F)) ;
##	 res = z./n ;
##      case "PHI1"
##	 s = F./(B-H+F) ;
##	 a = H.*s ;
##	 r = B.*s ;
##	 res = PHI(a,s,r) ;
      case "PC"
	 res = 1 + 2.*a - (s+r) ;
##      case "PC0"
##	 z = B - H - F.*B + 2.*H.*F ;
##	 n = B + F - H ;
##	 res = z./n ;
##      case "PC1"
##	 s = F./(B-H+F) ;
##	 a = H.*s ;
##	 r = B.*s ;
##	 res = PC(a,s,r) ;
      case "HSS"
	 z = a - s.*r ;
	 n = (s+r)/2 - s.*r ;
	 res = z./n ;
##      case "HSS0"
##	 z = 2.*(B-H).*(H-F) ;
##	 n = B.*(1+B-H-F) + F - H ;
##	 res = z./n ;
##      case "HSS1"
##	 s = F./(B-H+F) ;
##	 a = H.*s ;
##	 r = B.*s ;
##	 res = HSS(a,s,r) ;
      case "PSS"
	 z = a - s.*r ;
	 n = s.*(1-s) ;
	 res = z./n ;
      case "PSS0"
	 res = H - F ;
##      case "PSS1"
##	 s = F./(B-H+F) ;
##	 a = H.*s ;
##	 r = B.*s ;
##	 res = PSS(a,s,r) ;
      case "CSS"
	 z = a - s.*r ;
	 n = r.*(1-r) ;
	 if (n == 0)
	    res = NaN ;
	 else
	    res = z./n ;
	 end
##      case "CSS0"
##	 z = (H-F).*(B-H) ;
##	 n = B.*(B-H+F.*(1-B)) ;
##	 res = z./n ;
##      case "CSS1"
##	 s = F./(B-H+F) ;
##	 a = H.*s ;
##	 r = B.*s ;
##	 res = CSS(a,s,r) ;
      case "CSI"
	 res = a ./ (s+r-a) ;
##      case "CSI0"
##	 z = H ;
##	 n = 1 + B - H ;
##	 res = z./n ;
##      case "CSI1"
##	 s = F./(B-H+F) ;
##	 a = H.*s ;
##	 r = B.*s ;
##	 res = CSI(a,s,r) ;
      case {"GSS" "ETS"}
	 z = a - s.*r ;
	 n = s + r - a - s.*r ;
	 res = z./n ;
	 ##      case "GSS0"
##	 res = GSS1(B,H,F) ;
##      case "GSS1"
##	 s = F./(B-H+F) ;
##	 a = H.*s ;
##	 r = B.*s ;
##	 res = GSS(a,s,r) ;
      case "Q"
	 z = a - s.*r ;
	 n = a + s.*r - 2.*a.*(s+r-a) ;
	 if (n == 0)
	    res = NaN ;
	 else
	    res = z./n ;
	 end
##      case "Q0"
##	 z = H - F ;
##	 n = H + F - 2.*H.*F ;
##	 res = z./n ;
##      case "Q1"
##	 s = F./(B-H+F) ;
##	 a = H.*s ;
##	 r = B.*s ;
##	 res = Q(a,s,r) ;
      otherwise
	 error("skill %s unknown", skl) ;
   endswitch

endfunction

