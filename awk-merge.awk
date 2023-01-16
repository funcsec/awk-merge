#!/usr/bin/awk -f
BEGIN {
  FS=",";
}
{
      name=$1;
      email=$2;
      while ( (getline ln < template) > 0 )
      {
	      sub(/{name}/,name,ln);
	      sub(/{email}/,email,ln);
	      print ln;
      }
      close(template);
      exit;
}
