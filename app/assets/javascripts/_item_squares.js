function initPaginationListeners() {

  function onPageChanged(e, oldPage, newPage) {
    $('[class*=item-squares-page-' + oldPage + ']').hide();
    $('[class*=item-squares-page-' + newPage + ']').show();
  }

  var options = {
    currentPage: 1,
    totalPages: 5,
    size: 'large',
    bootstrapMajorVersion: 3,
    alignment: 'center',
    shouldShowPage: function(type, page, current) {
      switch (type) {
        case 'first':
        case 'last':
          return false;
        default:
          return true;
      }
    },
    onPageChanged: onPageChanged,
  }

  $('#pagination-bar').bootstrapPaginator(options);
  $("[title='Go to previous page']").parent().attr('class', '');
  $('#pagination-bar').click(function() {
    $("[title='Go to previous page']").parent().attr('class', '');
    $("[title='Go to next page']").parent().attr('class', '');
  });
}