#include <sys/types.h>
#include <sys/xattr.h>
#include <sys/acl.h>
#include <stdio.h>
#include <ruby.h>

VALUE MacExtendedAttribute;

VALUE get_xattr(VALUE self, VALUE path)
{
  char* pPath = StringValuePtr(path);
  acl_t acl = NULL;
  acl_entry_t dummy;
  ssize_t xattr = 0;

  acl = acl_get_link_np(pPath, ACL_TYPE_EXTENDED);
  if (acl && acl_get_entry(acl, ACL_FIRST_ENTRY, &dummy) == -1) {
      acl_free(acl);
      acl = NULL;
  }
  xattr = listxattr(pPath, NULL, 0, XATTR_NOFOLLOW);
  if (xattr < 0)
      xattr = 0;

  if (xattr > 0) {
      return rb_str_new2("@");
  } else if (acl != NULL) {
      return rb_str_new2("+");
  } else {
      return rb_str_new2(" ");
  }
}

void Init_mac_extended_attribute()
{
  MacExtendedAttribute = rb_define_module("MacExtendedAttribute");
  rb_define_module_function(MacExtendedAttribute, "get_xattr", RUBY_METHOD_FUNC(get_xattr), 1);
}
