// ----------------------------------------
// Theme: Universal Theme > List Template: Menu Bar > JavaScript > Execute when Page Loads

var e = apex.jQuery("##PARENT_STATIC_ID#_menubar", apex.gPageContext$);
if (e.hasClass("js-addActions")) {
  apex.actions.addFromMarkup( e );
}
e.menu({
  behaveLikeTabs: e.hasClass("js-tabLike"),
  menubarShowSubMenuIcon: e.hasClass("js-showSubMenuIcons") || null,
  iconType: 'fa',
  menubar: true,
  menubarOverflow: true,
  callout: e.hasClass("js-menu-callout")
});

// ----------------------------------------
// Theme: Universal Theme > List Template: Menu Popup > JavaScript > Execute when Page Loads

var e = apex.jQuery("##PARENT_STATIC_ID#_menu", apex.gPageContext$);
if (e.hasClass("js-addActions")) {
  apex.actions.addFromMarkup( e );
}
e.menu({ iconType: 'fa', callout: e.hasClass("js-menu-callout")});

// ----------------------------------------
// Theme: Universal Theme > List Template: Side Navigation Menu > JavaScript > Execute when Page Loads

apex.jQuery('body').addClass('t-PageBody--leftNav');

// ----------------------------------------
// Theme: Universal Theme > List Template: Top Navigation Menu > JavaScript > Execute when Page Loads

var e = apex.jQuery("#t_MenuNav", apex.gPageContext$);
if (e.hasClass("js-addActions")) {
  apex.actions.addFromMarkup( e );
}
e.menu({
  behaveLikeTabs: e.hasClass("js-tabLike"),
  menubarShowSubMenuIcon: e.hasClass("js-showSubMenuIcons") || null,
  menubar: true,
  menubarOverflow: true,
  callout: e.hasClass("js-menu-callout")
});


// ----------------------------------------
// Theme: Universal Theme > List Template: Wizard Progress > JavaScript > Execute when Page Loads

apex.theme.initWizardProgressBar();

