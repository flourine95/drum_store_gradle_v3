import com.drumstore.web.dto.RoleDTO;
import com.drumstore.web.repositories.PermissionRepository;
import com.drumstore.web.repositories.RoleRepository;
import com.drumstore.web.repositories.UserRepository;

public class Test {
    public static void main(String[] args) {
//        System.out.println(new PermissionRepository().createPermission("permissions:create", "description"));
//        System.out.println(new RoleRepository().createRole(RoleDTO.builder().name("ADMIN1").description("asd").build()));
        new RoleRepository().getAllRoles().forEach(System.out::println);
        RoleDTO roleRequest = RoleDTO.builder().id(null).name("ADMIN").description("description").build();
        System.out.println( new UserRepository().login("voxuandong14052004@gmail.com", "Dong@14052004"));
    }

}