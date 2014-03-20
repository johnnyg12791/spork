//* This file must be included on any page that uses the pagination plugin *//

function initPagination(numPages) {

  function onPageChanged(e, oldPage, newPage) {
    var prefix = $(e.target).attr('id').split('-')[0];
    $('[class*=' + prefix + '-squares-page-' + oldPage + '-]').hide();
    $('[class*=' + prefix + '-squares-page-' + newPage + '-]').show();
  }

  var options = {
    currentPage: 1,
    totalPages: numPages,
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

  $('ul[id*=-paginator]').each(function(index, element) {
    $(element).bootstrapPaginator(options);
  });

  $('ul[id*=-paginator]').each(function(index, element) {
    $(element).click(function() {
      $("[title='Go to previous page']").parent().attr('class', '');
      $("[title='Go to next page']").parent().attr('class', '');
    });
  });

  $("[title='Go to previous page']").parent().attr('class', '');
}