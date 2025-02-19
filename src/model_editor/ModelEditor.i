#ifndef MODELEDITOR_LIB_I
#define MODELEDITOR_LIB_I

#ifdef SWIGPYTHON
%module openstudiomodeleditor
#endif

#define UTILITIES_API
#define MODEL_API
#define MODELEDITOR_API

%include <openstudio/utilities/core/CommonInclude.i>
%import <openstudio/utilities/core/CommonImport.i>
%import <openstudio/utilities/Utilities.i>

#if defined(SWIGCSHARP) || defined(SWIGJAVA)
%import <openstudio/model/Model.i>
#else
%import(module="openstudiomodel") <openstudio/model/Model.hpp>
%import(module="openstudiomodel") <openstudio/model/ModelObject.hpp>
#endif

%{
  #include <model_editor/Application.hpp>
  #include <model_editor/GithubReleases.hpp>
  #include <model_editor/InspectorGadget.hpp>
  #include <model_editor/InspectorDialog.hpp>
  #include <model_editor/ModalDialogs.hpp>
  #include <model_editor/OSProgressBar.hpp>
  #include <model_editor/Utilities.hpp>

  #include <openstudio/model/Model.hpp>
  #include <openstudio/model/ModelObject.hpp>

  using namespace openstudio;
  using namespace openstudio::model;

  // to be ignored
  class QDomNode;
  class QDomElement;
  class QDomDocument;
  class QNetworkAccessManager;
  namespace openstudio{
    class ProgressBar;
    class UpdateManager;
    class IdfObjectWatcher;
    class BCL;
    class RemoteBCL;
    class LocalBCL;
    class WorkspaceObjectWatcher;
    class WorkspaceWatcher;
  }
%}

#if defined(SWIGCSHARP) || defined(SWIGJAVA)
%module(directors="1")
#endif
%{
  #include <model_editor/PathWatcher.hpp>
%}

%include <model_editor/Qt.i>

// it seems that SWIG tries to create conversions of QObjects to these
%ignore QDomNode;
%ignore QDomElement;
%ignore QDomDocument;
%ignore QNetworkAccessManager;
%ignore openstudio::UpdateManager;
%ignore openstudio::IdfObjectWatcher;
%ignore openstudio::BCL;
%ignore openstudio::RemoteBCL;
%ignore openstudio::LocalBCL;
%ignore openstudio::WorkspaceWatcher;

%template(Application) openstudio::Singleton<openstudio::ApplicationSingleton>;
%include <model_editor/Application.hpp>

%feature("director") PathWatcher;
%include <model_editor/PathWatcher.hpp>

%ignore std::vector<modeleditor::GithubRelease>::vector(size_type);
%ignore std::vector<modeleditor::GithubRelease>::resize(size_type);
%template(GithubReleaseVector) std::vector<modeleditor::GithubRelease>;

// DLM: I could not get director class working here, crashed when calling onFinished
//%feature("director") GithubReleases;
%include <model_editor/GithubReleases.hpp>

%extend modeleditor::GithubReleases{
  std::string __str__() const {
    std::ostringstream os;
    os << *self;
    return os.str();
  }
}
%extend modeleditor::GithubRelease{
  std::string __str__() const {
    std::ostringstream os;
    os << *self;
    return os.str();
  }
}

%include <model_editor/AccessPolicyStore.hpp>

%include <model_editor/InspectorGadget.hpp>

%include <model_editor/Utilities.hpp>

%feature("director") InspectorDialog;
%include <model_editor/InspectorDialog.hpp>

// do not know why SWIG is not pulling in these methods from QMainWindow base class
%extend InspectorDialog {
    void setVisible(bool visible){$self->setVisible(visible); }
    void setHidden(bool hidden){$self->setHidden(hidden); }
    void show(){$self->show(); }
    void hide(){$self->hide(); }

    void showMinimized(){$self->showMinimized(); }
    void showMaximized(){$self->showMaximized(); }
    void showFullScreen(){$self->showFullScreen(); }
    void showNormal(){$self->showNormal(); }

    bool close(){return $self->close(); }
    void raise(){$self->raise(); }
    void lower(){$self->lower(); }

    bool isActiveWindow() const {return $self->isActiveWindow(); }
    void activateWindow() {$self->activateWindow(); }
    bool isEnabled() const {return $self->isEnabled(); }
    void setEnabled(bool enabled) {$self->setEnabled(enabled); }
    bool isFullScreen() const {return $self->isFullScreen(); }
    bool isHidden() const {return $self->isHidden(); }
    bool isMaximized() const {return $self->isMaximized(); }
    bool isMinimized() const {return $self->isMinimized(); }
    bool isModal() const {return $self->isModal(); }
    bool isVisible() const {return $self->isVisible(); }
    void setVisible(bool visible) {$self->setVisible(visible); }
};

%feature("director") ModelObjectSelectorDialogWatcher;
%include <model_editor/ModalDialogs.hpp>

%feature("director") OSProgressBar;
%include <model_editor/OSProgressBar.hpp>

#endif //MODELEDITOR_LIB_I
