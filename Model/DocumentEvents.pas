unit DocumentEvents;

interface

const
  EVENT_DOCUMENT_CLEAR                = 1 shl 0;
  EVENT_DOCUMENT_LOAD                 = 1 shl 1;
  EVENT_DOCUMENT_CREATE_GROUP         = 1 shl 2;
  EVENT_DOCUMENT_DESTROY_GROUP        = 1 shl 3;
  EVENT_DOCUMENT_SELECT_GROUP         = 1 shl 4;
  EVENT_DOCUMENT_CREATE_MODULE        = 1 shl 5;
  EVENT_DOCUMENT_DESTROY_MODULE       = 1 shl 6;

  EVENT_GROUP_CLEAR                   = 1 shl 0;
  EVENT_GROUP_CREATE_MODULE           = 1 shl 1;
  EVENT_GROUP_DESTROY_MODULE          = 1 shl 2;
  EVENT_GROUP_SELECT_MODULE           = 1 shl 3;
  EVENT_GROUP_SELECTED_CHANGED        = 1 shl 4;

  EVENT_MODULE_CLEAR                  = 1 shl 0;
  EVENT_MODULE_NAME_CHANGED           = 1 shl 1;
  EVENT_MODULE_SELECTED_CHANGED       = 1 shl 2;
  EVENT_MODULE_MINIMIZED_CHANGED      = 1 shl 3;

implementation

end.
